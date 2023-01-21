#ifndef TA_VERT
#define TA_VERT

v2f vert(appdata v)
{
    v2f o;

    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(v2f, o);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    
    o.pos = UnityObjectToClipPos(v.vertex);
    o.posWS = mul(unity_ObjectToWorld, v.vertex).xyz;

    // UV
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.subTexUV = o.uv;

    // SubTex UV Animation
    if(_SubTexScrollX != 0) o.subTexUV.x += (_Time.y * _SubTexScrollSpeed) * _SubTexScrollX;
    if(_SubTexScrollY != 0) o.subTexUV.y += (_Time.y * _SubTexScrollSpeed) * _SubTexScrollY;

    // Decal
    o.decal = (float4)1.;
    if(_UseDecal)
    {
        float2 decalPos = float2(_DecalPosX, _DecalPosY);
        float2 decalSize = float2(_DecalSizeX, _DecalSizeY);
        
        float2 sizeRatio = (float2)1.;
        float2 aniSpeed = (float2)0.;
        if(_UseDecalAnimation)
        {
            sizeRatio = 1. / TA_COMPARE_EPS(_FrameNum);
            aniSpeed = _DecalAnimationSpeed * _Time.y;
            aniSpeed.y *= -sizeRatio.y;
            aniSpeed = floor(frac(aniSpeed) * _FrameNum);
        }
        if(_DecalTex_TexelSize.z < _DecalTex_TexelSize.w) decalSize.x *= _DecalTex_TexelSize.y * _DecalTex_TexelSize.z;
        if(_DecalTex_TexelSize.z > _DecalTex_TexelSize.w) decalSize.y *= _DecalTex_TexelSize.x * _DecalTex_TexelSize.w;
        float2 decalScale = 1. / TA_COMPARE_EPS(decalSize);
        float2x2 decalRotMat = TA_ROT(_DecalRot * TA_DEG2RAD);
        float2 decalHalfSize = decalSize * .5;

        o.decal.xy = o.uv.xy - decalPos + decalHalfSize;
        o.decal.xy = mul(decalRotMat, o.decal.xy - decalHalfSize) + decalHalfSize;
        o.decal.xy *= decalScale * sizeRatio;
        o.decal.zw = aniSpeed * sizeRatio;
    }

    // Camera
    float3 cameraViewDir = -UNITY_MATRIX_V._m20_m21_m22;

    // Normal
    o.normal = v.normal;
    float3 normalWS = UnityObjectToWorldNormal(v.normal);
    float3 tangentWS = UnityObjectToWorldDir(v.tangent.xyz);
    float tangentSign = v.tangent.w * unity_WorldTransformParams.w;
    float3 bitangentWS = cross(normalWS, tangentWS) * tangentSign;

    o.tspace0 = float3(tangentWS.x, bitangentWS.x, normalWS.x);
    o.tspace1 = float3(tangentWS.y, bitangentWS.y, normalWS.y);
    o.tspace2 = float3(tangentWS.z, bitangentWS.z, normalWS.z);

    #ifdef FA
        UNITY_TRANSFER_LIGHTING(o, v.uv1);
    #endif

    // LightDir
    float isLight = (_LightColor0.r + _LightColor0.g + _LightColor0.b) < TA_EPS ? 0. : 1.;      // DLがあるか判定

    float3 groundCol = saturate(ShadeSH9(half4(0., -1., 0., 1.)));
    float3 skyCol = saturate(ShadeSH9(half4(0., 1., 0., 1.)));
    float isBrightest = step(GetValueColor(groundCol), GetValueColor(skyCol));
    float3 defaultLightDir = float3(-cameraViewDir.x, lerp(-1., 1., isBrightest), -cameraViewDir.z);
    
    #ifdef FB
        o.lightDirWS.xyz = normalize(lerp(defaultLightDir, UnityWorldSpaceLightDir(o.posWS), isLight));
        o.lightDirWS.w = isLight;
    #endif
    #ifdef FA
        o.lightDirWS.xyz = normalize(UnityWorldSpaceLightDir(o.posWS));
        o.lightDirWS.w = isLight;
    #endif
    
    // LightColor
    #ifdef FB
        float3 vertexLight = 0.;
        #ifdef VERTEXLIGHT_ON
            vertexLight = Shade4PointLights(
                unity_4LightPosX0,
                unity_4LightPosY0,
                unity_4LightPosZ0,
                unity_LightColor[0].rgb,
                unity_LightColor[1].rgb,
                unity_LightColor[2].rgb,
                unity_LightColor[3].rgb,
                unity_4LightAtten0,
                o.posWS,
                normalWS);
        #endif

        float3 sh=(float3)_MinBrightness;
        
        o.lightCol = lerp((groundCol + skyCol), _LightColor0, isLight) + vertexLight;
        o.sh = sh + vertexLight;
    #endif

    #ifdef FA
        o.lightCol = _LightColor0;
    #endif

    // VertexColor
    o.vertColor.rgb = (float3)1.;
    o.vertColor.a = 1.;
    if(_UseVertCol) o.vertColor = v.color;

    // Fog
    UNITY_TRANSFER_FOG(o, o.pos);

    return o;
}

#endif