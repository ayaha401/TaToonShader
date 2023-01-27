#ifndef TA_CORE
#define TA_CORE

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"
#include "../HLSL/TaToon_Macro.hlsl"
#include "../HLSL/TaToon_Function.hlsl"

// MainTexSampler
uniform SamplerState mainTex_linear_clamp_sampler;

// MainColor
uniform Texture2D _MainTex; uniform float4 _MainTex_ST;
uniform float4 _Color;
uniform int _UseVertCol;
#if defined(TRANSPARENT) || defined(CUTOUT)
    uniform Texture2D _AlphaMask; uniform float4 _AlphaMask_ST;
#endif

#ifdef CUTOUT
    uniform float _Cutout;
#endif

// SubTexture
uniform int _UseSubTex;
uniform Texture2D _SubTex; uniform float4 _SubTex_ST;
uniform SamplerState sampler_SubTex;
uniform Texture2D _SubTexBumpMap;
uniform float _SubTexBumpScale;
uniform int _SubTexMode;
uniform int _SubTexCullingMode;
uniform float3 _SubTexColor;
uniform int _SubTexColorMode;
uniform float _SubTexColorChange;
uniform Texture2D _SubTexMask;
uniform float _SubTexMaskIntensity;
uniform float _SubTexScrollX;
uniform float _SubTexScrollY;
uniform int _UseSubTexEmission;
uniform float3 _SubTexEmissionColor;
uniform float _SubTexEmissionMaskIntensity;
uniform int _SubTexEmissionFlickerMode;
uniform float _SubTexEmissionFrequency;

// Decal
uniform int _UseDecal;
uniform Texture2D _DecalTex; uniform float4 _DecalTex_TexelSize;
uniform SamplerState sampler_DecalTex;
uniform Texture2D _DecalBumpMap;
uniform float _DecalBumpScale;
uniform int _DecalMode;
uniform int _UseDecalAnimation;
uniform float2 _FrameNum;
uniform float _DecalAnimationSpeed;
uniform float _DecalPosX;
uniform float _DecalPosY;
uniform float _DecalSizeX;
uniform float _DecalSizeY;
uniform float _DecalRot;
uniform int _UseDecalEmission;
uniform float3 _DecalEmissionColor;
uniform int _DecalEmissionFlickerMode;
uniform float _DecalEmissionFrequency;

// Normal
uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
uniform float _BumpScale;

// Shade
uniform Texture2D _ShadeMask;
uniform float4 _ShadeColor;
uniform float _ShadeBorder;
uniform float _ShadeBorderWidth;
uniform float _Brightness;

// Emission
uniform int _UseEmission;
uniform Texture2D _EmissionMask;
uniform float3 _EmissionColor;
uniform int _EmissionFlickerMode;
uniform float _EmissionFrequency;

// Rimlight
uniform int _UseRim;
uniform Texture2D _RimMask;
uniform float3 _RimColor;
uniform float _RimPower;
uniform float _RimWidth;
#if defined(TRANSPARENT)
    uniform int _IgnoreAlphaRimlight;
#endif

// Reflection
uniform int _UseReflect;
uniform Texture2D _ReflectMask;
uniform float _Smoothness;
uniform float _SpecularPower;
uniform sampler2D _MatCapTex;
#if defined(TRANSPARENT)
    uniform int _IgnoreAlphaReflection;
#endif

// OtherSetting
#ifdef FB
    uniform float _MinBrightness;
#endif
#ifdef FA
    uniform bool _PointLightLimit;
#endif
uniform float _SubTexScrollSpeed;
uniform sampler2D _RampTex;

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;
    float4 tangent : TANGENT;
    float2 uv1 : TEXCOORD1;
    float4 color : COLOR;
    float2 decalUV : TEXCOORD2;

    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
    float2 uv : TEXCOORD0;
    float4 pos : SV_POSITION;
    float3 posWS : TEXCOORD1;
    float3 normal : NORMAL;
    float4 vertColor : COLOR;
    float2 subTexUV : SUB0;
    float4 decal : DECAL0;      // x : u, y : v, z : Animation u, w : Animation v
    float4 lightDirWS : TEXCOORD2;      // w : isLight
    float3 lightCol : TEXCOORD3;
    float3 tspace0 : TEXCOORD4;
    float3 tspace1 : TEXCOORD5;
    float3 tspace2 : TEXCOORD6;
    #ifdef FA
        UNITY_LIGHTING_COORDS(7, 8)
    #endif
    float3 sh : TEXCOORD9;
    UNITY_FOG_COORDS(10)
    UNITY_VERTEX_OUTPUT_STEREO
};

#include "../HLSL/TaToon_Vert.hlsl"
#include "../HLSL/TaToon_Frag.hlsl"

#endif