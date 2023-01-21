#ifndef TA_OUTLINE
#define TA_OUTLINE

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "../HLSL/TaToon_Macro.hlsl"
#include "../HLSL/TaToon_Function.hlsl"

// Sampler
SamplerState mainTex_linear_clamp_sampler;

// MainColor
Texture2D _MainTex; uniform float4 _MainTex_ST;

// Shading
uniform float _Brightness;

// Outline
uniform sampler2D _OutlineMask;
uniform bool _UseOutline;
uniform float _OutlineWidth;
uniform float4 _OutlineColor;
uniform bool _UseLightColor;

// OtherSetting
uniform float _MinBrightness;

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;

    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float3 posWS : TEXCOORD1;
    float4 vertex : SV_POSITION;
    float4 color : COLOR;
    float3 lightCol : TEXCOORD2;
    float3 sh : TEXCOORD3;
    float3 normal : NORMAL;

    UNITY_FOG_COORDS(4)

    UNITY_VERTEX_OUTPUT_STEREO
};

v2f vert(appdata v)
{
    v2f o = (v2f)0.;

    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_OUTPUT(v2f, o);
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

    o.posWS = mul(unity_ObjectToWorld, v.vertex).xyz;

    // UV
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);

    // Normal
    o.normal = v.normal;
    float3 normalWS = UnityObjectToWorldNormal(v.normal);
    
    // OutlineColor
    o.color = (float4)0.;
    if(_UseOutline)
    {
        float3 scale = .1 / ObjectScale();
        float3 outlineVert = v.normal * (_OutlineWidth * .5) * scale;
        float outlineMask = tex2Dlod(_OutlineMask, float4(o.uv, 0., 0.)).r;
        outlineVert *= outlineMask;
        v.vertex.xyz += outlineVert;

        o.color = float4(_OutlineColor.rgb, 1.);
        #if defined(TRANSPARENT) || defined(CUTOUT)
            o.color.a = _OutlineColor.a;
        #endif
    }
    else
    {
        v.vertex.xyz = (float3)0.;
    }

    o.lightCol = (float3)0.;
    if(_UseLightColor)
    {
        // LightDir
        float isLight = (_LightColor0.r + _LightColor0.g + _LightColor0.b) < TA_EPS ? 0. : 1.;      // DLがあるか判定

        float3 groundCol = saturate(ShadeSH9(half4(0., -1., 0., 1.)));
        float3 skyCol = saturate(ShadeSH9(half4(0., 1., 0., 1.)));

        // LightColor
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

        float3 sh = (float3)_MinBrightness;
        o.lightCol = lerp((groundCol + skyCol), _LightColor0, isLight) + vertexLight;
        o.lightCol = lerp(o.lightCol, o.lightCol * (GetValueColor(groundCol + skyCol) - sh * .5), isLight);
        o.lightCol = saturate(o.lightCol);

        o.sh = sh + vertexLight;
    }

    o.vertex = UnityObjectToClipPos(v.vertex);

    // Fog
    UNITY_TRANSFER_FOG(o, o.pos);

    return o;
}

float4 frag(v2f i) : SV_Target
{
    // Light
    float3 lightCol = (float3)0.;
    float3 shCol = (float3)0.;
    if(_UseLightColor)
    {
        lightCol = i.lightCol;
        shCol = i.sh;
    }

    // OutlineColor
    float4 col = float4(i.color);
    
    // Light
    float3 lightColor = lightCol;
    float3 lighting = (float3)0.;
    if(_UseLightColor)
    {
        // DL
        lighting = lightColor;
        col.rgb *= lighting;

        // IL
        col.rgb += shCol * _OutlineColor.rgb;
        col.rgb = min(col.rgb, _OutlineColor.rgb);
    }


    float4 lastCol = col;

    // Fog
    UNITY_APPLY_FOG(IN.fogCoord, lastCol);
    
    return lastCol;
}

#endif