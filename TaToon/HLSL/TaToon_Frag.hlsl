#ifndef TA_FRAG
#define TA_FRAG

float4 frag(v2f i, bool isFrontFace : SV_IsFrontFace) : SV_Target
{
    // IsFront
    int isFront = (int)isFrontFace;

    // CameraPos
    float3 cameraPosWS = -UNITY_MATRIX_I_V._m03_m13_m23;

    // View
    float3 cameraViewWS = normalize(-cameraPosWS - i.posWS);
    float3 cameraViewCS = mul((float3x3)UNITY_MATRIX_V, cameraViewWS);

    // Normal
    float3 tangentNormal = UnpackNormalWithScale(tex2D(_BumpMap, i.uv), _BumpScale);
    float3 normalWS;
    normalWS.x = dot(i.tspace0, tangentNormal);
    normalWS.y = dot(i.tspace1, tangentNormal);
    normalWS.z = dot(i.tspace2, tangentNormal);
    normalWS = normalize(normalWS);

    float3 normalCS = mul((float3x3)UNITY_MATRIX_V, normalWS);

    // Light
    float3 lightDir = i.lightDirWS;
    float3 lightCol = i.lightCol;
    float isLight = i.lightDirWS.w;
    float3 shCol = i.sh;

    // SubTexture
    float4 subTexCol = (float4)0.;
    float3 subTexEmissionCol = (float3)0.;
    if(_UseSubTex)
    {
        // SubTexture Color
        subTexCol = _SubTex.Sample(sampler_SubTex, i.subTexUV);
        float subTexMask = saturate(_SubTexMask.Sample(sampler_SubTex, i.subTexUV).r - _SubTexMaskIntensity);
        float subTexColorChangeMask = saturate(_SubTexMask.Sample(sampler_SubTex, i.subTexUV).g - (1. - _SubTexColorChange));
        
        if(_SubTexColorMode == 0) subTexCol.rgb *= lerp(subTexCol.rgb, _SubTexColor, subTexColorChangeMask);
        if(_SubTexColorMode == 1) subTexCol.rgb = lerp(subTexCol.rgb, _SubTexColor, subTexColorChangeMask);
        
        // SubTexture Emission
        if(_UseSubTexEmission)
        {
            float subTexEmissionMask = saturate(_SubTexMask.Sample(sampler_SubTex, i.subTexUV).b - _SubTexEmissionMaskIntensity);
            subTexEmissionCol = _SubTexEmissionColor * subTexEmissionMask;
            subTexEmissionCol *= Wave(_SubTexEmissionFlickerMode, _SubTexEmissionFrequency);
            if((_SubTexMode == 0) | (_SubTexMode == 2))
            {
                subTexCol.rgb += subTexEmissionCol;
            }
        }

        // SubTexture Culling
        subTexCol.a *= subTexMask;
        if(_SubTexCullingMode == 1) subTexCol.a *= 1 - isFront;
        if(_SubTexCullingMode == 2) subTexCol.a *= isFront;

        // SubTexture Normal
        float3 subTexNormal = UnpackNormalWithScale(_SubTexBumpMap.Sample(sampler_SubTex, i.subTexUV), _SubTexBumpScale);
        subTexNormal *= subTexMask;
        subTexNormal.z = subTexNormal.z == 0. ? .5 : subTexNormal.z;
        normalWS = Blend_RNM(normalWS, subTexNormal);
    }

    // Decal
    float4 decalCol = (float4)0;
    float3 decalEmissionCol = (float3)0.;
    if(_UseDecal)
    {
        float2 decalUV = i.decal.xy + i.decal.zw;
        float2 sizeRatio = (float2)1;
        if(_UseDecalAnimation)
        {
            sizeRatio = 1. / TA_COMPARE_EPS(_FrameNum);
        }
        
        // Decal Color
        decalCol = _DecalTex.Sample(sampler_DecalTex, decalUV);
        decalCol.a *= (step(abs(i.decal.x - sizeRatio.x * .5), sizeRatio.x * .5)) *
                      (step(abs(i.decal.y - sizeRatio.y * .5), sizeRatio.y * .5));

        // Decal Emission
        if(_UseDecalEmission)
        {
            float decalEmissionMask = decalCol.a;
            decalEmissionCol = _DecalEmissionColor * decalEmissionMask;
            decalEmissionCol *= Wave(_DecalEmissionFlickerMode, _DecalEmissionFrequency);
            if((_DecalMode == 0) | (_DecalMode == 2))
            {
                decalCol.rgb += decalEmissionCol;
            }
        }

        // Decal Normal
        float3 decalNormal = UnpackNormalWithScale(_DecalBumpMap.Sample(sampler_DecalTex, decalUV), _DecalBumpScale);
        decalNormal *= (step(abs(i.decal.x - sizeRatio.x * .5), sizeRatio.x * .5)) *
                       (step(abs(i.decal.y - sizeRatio.y * .5), sizeRatio.y * .5));
        decalNormal.z = decalNormal.z == 0. ? .5 : decalNormal.z;
        normalWS = Blend_RNM(normalWS, decalNormal);
    }

    // Diff
    float NdotL = dot(normalWS, lightDir);
    float halfLambert = NdotL * .5 + .5;

    float diff = halfLambert;
    diff += _ShadeBorder * .5;
    diff = clamp(((diff - .5) / TA_COMPARE_EPS(_ShadeBorderWidth)) + .5 + (_Brightness * .5), _Brightness, 1.);
    float shadeMask = _ShadeMask.Sample(mainTex_linear_clamp_sampler, i.uv);
    diff = max(shadeMask, diff);

    float3 albedo = _MainTex.Sample(mainTex_linear_clamp_sampler, i.uv) * _Color.rgb * i.vertColor.rgb;

    // SubTexture
    if(_UseSubTex)
    {
        if(_SubTexMode == 0) albedo.rgb = lerp(albedo.rgb, subTexCol.rgb, subTexCol.a);
        if(_SubTexMode == 1) albedo.rgb = saturate(albedo.rgb + subTexCol.rgb * subTexCol.a) + subTexEmissionCol;
        if(_SubTexMode == 2) albedo.rgb = lerp(albedo.rgb, albedo.rgb * subTexCol.rgb, subTexCol.a);
    }

    // DecalColor
    if(_UseDecal)
    {
        if(_DecalMode == 0) albedo.rgb = lerp(albedo.rgb, decalCol.rgb, decalCol.a);
        if(_DecalMode == 1) albedo.rgb = saturate(albedo.rgb + decalCol.rgb * decalCol.a) + decalEmissionCol;
        if(_DecalMode == 2) albedo.rgb = lerp(albedo.rgb, albedo.rgb * decalCol.rgb, decalCol.a);
    }

    float3 shade = _ShadeColor;
    float3 diffCol = lerp(shade, albedo, diff);
    
    float4 col = float4(0., 0., 0., 1.);
    col.rgb = diffCol;
    #if defined(TRANSPARENT) || defined(CUTOUT)
        col.a = _MainTex.Sample(mainTex_linear_clamp_sampler, i.uv).a * _Color.a;
        col.a *= _AlphaMask.Sample(mainTex_linear_clamp_sampler, i.uv).r;
    #endif

    // Cutout
    #ifdef CUTOUT
        clip(col.a - _Cutout);
    #endif

    // Light
    float3 lighting = 0.;
    #ifdef FB
        // DL
        lighting = lightCol;
        col.rgb *= lighting;
        
        // IL
        col.rgb += shCol * albedo;
        col.rgb = min(col.rgb, albedo);
    #endif

    #ifdef FA
        //PL
        UNITY_LIGHT_ATTENUATION(atten, i, i.posWS);
        float a = (max(diff * 2. - 1., 0.)) * atten * max(NdotL, 0.);
        lighting = a * lightCol;
        lighting = lerp(lighting, a * saturate(lightCol), _PointLightLimit);
        
        col.rgb *= lighting;
    #endif

    // Emission
    float3 emission = (float3)0.;
    if(_UseEmission)
    {
        float emissionMask = _EmissionMask.Sample(mainTex_linear_clamp_sampler, i.uv).r;
        emission = _EmissionColor * emissionMask;
        emission *= Wave(_EmissionFlickerMode, _EmissionFrequency);

        #ifdef FA
            emission *= lighting;
        #endif
    }

    // Rimlight
    float3 rimlight = (float3)0.;
    float rim = 0.;
    if(_UseRim)
    {
        float rimMask = _RimMask.Sample(mainTex_linear_clamp_sampler, i.uv).r;
        rim = CalcRimlight(cameraViewWS, normalWS, _RimWidth, _RimPower);
        rim *= rimMask;
        rimlight = (float3)rim * _RimColor;
        
        #ifdef FA
            rimlight *= lighting;
        #endif
    }

    // Reflection
    float3 specular = (float3)0.;
    float spec = 0.;
    float3 materialCapture = (float3)0.;
    if(_UseReflect)
    {
        float reflectMask = _ReflectMask.Sample(mainTex_linear_clamp_sampler, i.uv).r;
        float smoothness = max(_Smoothness, .05) * 100.;
        float specularInt = _SpecularPower;

        // Specular
        float3 hv = normalize(lightDir + cameraViewWS);
        spec = CalcSpecular(hv, normalWS, smoothness);
        spec *= reflectMask;
        specular = (float3)spec;
        specular *= specularInt;

        #ifdef FA
            specular *= lighting;
        #endif

        // Material Capture
        float3 matCapViewCS = cameraViewCS * float3(-1., -1., 1.);
        float2 matCapUV = Blend_RNM(matCapViewCS, normalCS).xy * .5 + .5;
        materialCapture = CalcMatCap(_MatCapTex, matCapUV);
        materialCapture *= reflectMask;
        
        #ifdef FA
            materialCapture *= lighting;
        #endif
    }

    // Calc Last Color
    float4 lastCol = float4(0., 0., 0., 1.);
    lastCol.rgb = col.rgb;
    lastCol.rgb += emission;
    lastCol.rgb += rimlight;
    lastCol.rgb += specular;
    lastCol.rgb += materialCapture;

    #if defined(TRANSPARENT)
        lastCol.a = col.a;

        // Ignore Alpha
        lastCol.a = saturate(lastCol.a + ConvertMonochrome(rimlight) * _IgnoreAlphaRimlight);
        lastCol.a = saturate(lastCol.a + ConvertMonochrome(materialCapture) * _IgnoreAlphaReflection);
    #endif

    // Fog
    UNITY_APPLY_FOG(IN.fogCoord, lastCol);
    
    return lastCol;
}

#endif