Shader "TaToon/Transparent_DoubleSided"
{
    Properties
    {
        // MainColor
        _MainTex("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
        [Toggle] _UseVertCol("Use Vertex Color", int) = 0
        _AlphaMask("Alpha Mask", 2D) = "white" {}

        // SubTexture
        [Toggle] _UseSubTex("Use SubTexture", int) = 0
        _SubTex("SubTexture", 2D) = "white" {}
        _SubTexBumpMap("SubTexture Normal Map", 2D) = "bump" {}
        _SubTexBumpScale("SubTexture Normal Scale", Range(0, 1)) = 1
        [Enum(Normal, 0, Add, 1, Multiply, 2)] _SubTexMode("SubTexture Mode", int) = 0
        [Enum(Off, 0, Front, 1, Back, 2)] _SubTexCullingMode("SubTexture CullingMode", int) = 2
        _SubTexColor("SubTexture Color", Color) = (1, 1, 1, 1)
        [Enum(Multiply, 0, Fill, 1)] _SubTexColorMode("SubTexture Color Mode", int) = 0
        _SubTexColorChange("SubTexture Color Change", Range(0, 1)) = 0
        _SubTexMask("SubTexture Mask",2D) = "white" {}
        _SubTexMaskIntensity("SubTexture Mask Intensity", Range(0, 1)) = 1
        _SubTexScrollX("SubTexture Scroll X", Range(-1, 1)) = 0
        _SubTexScrollY("SubTexture Scroll Y", Range(-1, 1)) = 0
        [Toggle] _UseSubTexEmission("Use SubTexture Emission", int) = 0
        [HDR] _SubTexEmissionColor("SubTexture Emission Color", Color) = (0, 0, 0, 0)
        _SubTexEmissionMaskIntensity("SubTexture Emission Mask Intensity", Range(0, 1)) = 0
        [Enum(LINE,0, SIN,1, SAW,2, TRIANGLE,3, SQUARE,4)] _SubTexEmissionFlickerMode("SubTexture Emission Flicker Mode", int) = 0
        _SubTexEmissionFrequency("SubTexture Emission Flicker Frequency", float) = 1

        // Decal
        [Toggle] _UseDecal("Use Decal", int) = 0
        _DecalTex("Decal Texture", 2D) = "white" {}
        _DecalBumpMap("Decal Normal Map", 2D) = "bump" {}
        _DecalBumpScale("Decal Normal Scale", Range(0, 1)) = 1
        [Enum(Normal, 0, Add, 1, Multiply, 2)] _DecalMode("Decal Mode", int) = 0
        [Toggle] _UseDecalAnimation("Use Decal Animation", int) = 0
        [Vec2] _FrameNum("Frame Num", Vector) = (0, 0, 0, 0)
        _DecalAnimationSpeed("Decal Animation Speed", float) = 0
        _DecalPosX("Decal Position X", Range(0, 1)) = 0.5
        _DecalPosY("Decal Position Y", Range(0, 1)) = 0.5
        _DecalSizeX("Decal Size X", Range(0, 1)) = 0.5
        _DecalSizeY("Decal Size Y", Range(0, 1)) = 0.5
        _DecalRot("Decal Rotation", Range(0, 360)) = 0
        [Toggle] _UseDecalEmission("Use Decal Emission", int) = 0
        [HDR] _DecalEmissionColor("Decal Emission Color", Color) = (0, 0, 0, 0)
        [Enum(LINE,0, SIN,1, SAW,2, TRIANGLE,3, SQUARE,4)] _DecalEmissionFlickerMode("Decal Emission Flicker Mode", int) = 0
        _DecalEmissionFrequency("Decal Emission Flicker Frequency", float) = 1

        // Normal
        _BumpMap("Normal Map", 2D) = "bump" {}
        _BumpScale("Normal Scale", Range(0, 1)) = 1

        // Shading
        _ShadeMask("Shade Mask", 2D) = "black" {}
        _ShadeColor("Shade Color", Color) = (0, 0, 0, 1)
        _ShadeBorder("Shade Border", Range(-1, 1)) = 0
        _ShadeBorderWidth("Shade Border Width", Range(0, 1)) = 0.5
        _Brightness("Brightness", Range(0, 1)) = 0

        // Emission
        [Toggle] _UseEmission("Use Emission", int) = 0
        _EmissionMask("Emission Mask", 2D) = "black" {}
        [HDR] _EmissionColor("Emission Color", Color) = (0, 0, 0, 0)
        [Enum(LINE,0, SIN,1, SAW,2, TRIANGLE,3, SQUARE,4)] _EmissionFlickerMode("Emission Flicker Mode", int) = 0
        _EmissionFrequency("Emission Flicker Frequency", float) = 1

        // Rimlight
        [Toggle] _UseRim("Use Rimlight", int) = 0
        _RimMask("Rimlight Mask", 2D) = "white" {}
        _RimColor("Rimlight Color", Color) = (1, 1, 1, 1)
        _RimPower("Rimlight Power", Range(0, 100)) = 1
        _RimWidth("Rimlight Width", Range(0, 1)) = 0.1
        [Toggle] _IgnoreAlphaRimlight("Ignore Alpha Rimlight", int) = 0
        
        // Reflection
        [Toggle] _UseReflect("Use Reflection", int) = 0
        _ReflectMask("Reflect Mask", 2D) = "white" {}
        _Smoothness("Smoothness", Range(0, 1)) = 0.5
        _SpecularPower("Specular Power", Range(0, 1)) = 0.5
        _MatCapTex("MatCap Texture", 2D) = "black" {}
        [Toggle] _IgnoreAlphaReflection("Ignore Alpha Reflection", int) = 0

        // Outline
        [Toggle] _UseOutline("Use Outline", int) = 0
        _OutlineMask("Outline Mask Texture", 2D) = "white" {}
        _OutlineWidth("Outline Width", Range(0, 1)) = 0.5
        _OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
        [Toggle] _UseLightColor("Use Light Color", int) = 0

        // OtherSetting
        [Enum(Off,0 ,Front,1, Back,2)] _CullingMode("Culling", int) = 0
        [Toggle] _EnableZWrite("ZWrite", int) = 1
        _MinBrightness("Min Brightness", Range(0, 1)) = 0.5
        [Toggle] _PointLightLimit("PointLight Limit", int) = 1
        _SubTexScrollSpeed("SubTexture Scroll Speed", float) = 1
        _RampTex("Ramp Texture", 2D) = "wite" {}
    }
    SubShader
    {
        Tags 
        {
            "IgnoreProjector" = "False"
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }
        LOD 0

        Pass
        {
            Name "ForwardBaseFront"
            Tags
            {
                "LightMode" = "ForwardBase"
            }

            Cull Front
            ZWrite ON
            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d11 metal	
            #pragma target 4.5
            #pragma enable_d3d11_debug_symbols

            #define FB
            #define TRANSPARENT
            #include "../TaToon/HLSL/TaToon_Core.hlsl"
            
            ENDHLSL
        }

        Pass
        {
            Name "Outline"
            Tags
            {
                "LightMode"="ForwardBase"
            }

            Cull Front
            ZWrite On
            Blend SrcAlpha OneMinusSrcAlpha
            ZTest Less

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d11 metal	
            #pragma target 4.5
            #pragma enable_d3d11_debug_symbols

            #define OL
            #define TRANSPARENT

            #include "../TaToon/HLSL/TaToon_Outline.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "ForwardBaseBack"
            Tags
            {
                "LightMode" = "ForwardBase"
            }

            Cull Back
            ZWrite ON
            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d11 metal	
            #pragma target 4.5
            #pragma enable_d3d11_debug_symbols

            #define FB
            #define TRANSPARENT
            #define BACK
            #include "../TaToon/HLSL/TaToon_Core.hlsl"
            
            ENDHLSL
        }

        Pass
        {
            Name "ForwardAdd"
            Tags
            {
                "LightMode" = "ForwardAdd"
            }

            Cull [_CullingMode]

            Blend SrcAlpha One
            ZWrite Off

            HLSLPROGRAM
            #pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdadd
			#pragma multi_compile_fog
            #pragma only_renderers d3d11 metal	
            #pragma target 4.5
            #pragma enable_d3d11_debug_symbols

            #define FA
            #define TRANSPARENT

            #include "../TaToon/HLSL/TaToon_Core.hlsl"
            
            ENDHLSL
        }

        pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            Cull Off
            ZWrite On
            ZTest LEqual

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d11 metal
            #pragma target 4.5
            #pragma enable_d3d11_debug_symbols

            #define SC
            #define TRANSPARENT
            #include "../TaToon/HLSL/TaToon_ShadowCaster.hlsl"

            ENDHLSL
        }
    }
    CustomEditor "AyahaShader.TaToon.TaToonGUI"
}
