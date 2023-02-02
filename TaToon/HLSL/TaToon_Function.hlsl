#ifndef TA_FUNCTION
#define TA_FUNCTION

// モノクロ変換
inline float ConvertMonochrome(float3 rgbCol)
{
    return dot(rgbCol, float3(.299, .587, .114));
}

// オブジェクトの大きさを計算
inline float3 ObjectScale()
{
    float3 scale = float3(
                            length(float3(unity_ObjectToWorld[0].x , unity_ObjectToWorld[1].x , unity_ObjectToWorld[2].x)),
	                        length(float3(unity_ObjectToWorld[0].y , unity_ObjectToWorld[1].y , unity_ObjectToWorld[2].y)),
	                        length(float3(unity_ObjectToWorld[0].z , unity_ObjectToWorld[1].z , unity_ObjectToWorld[2].z))
                        );

    scale = TA_COMPARE_EPS(scale);
    return scale;
}

// HSVのVをRGBから計算
inline float GetValueColor(float3 rgbCol)
{
    return max(rgbCol.r, max(rgbCol.g, rgbCol.b));
}

// RGBからVで明度を調整する。
inline float3 AdjustRGBWithV(float3 rgb, bool isBright, float v)
{
    return lerp(rgb, (float3)isBright, v);
}

// 法線を合成する
// https://docs.unity3d.com/Packages/com.unity.shadergraph@6.9/manual/Normal-Blend-Node.html
inline float3 Blend_RNM(float3 n1, float3 n2)
{
    float3 t = n1 + float3(0., 0., 1.);
    float3 u = n2 * float3(-1., -1., 1.);
    float3 r = normalize(t * dot(t, u) - u * t.z);
    return r;
}

// Rimlightを計算する
inline float CalcRimlight(float3 V, float3 N, float width, float intensity)
{
    float rim = pow(saturate(1. - dot(V, N) + width), intensity);
    rim = saturate(rim);
    return rim;
}

// Specularを計算する
inline float CalcSpecular(float3 HV, float3 N, float smoothness)
{
    float spec = pow(saturate(dot(HV, N)), smoothness);
    spec = saturate(spec);
    return spec;
}

// MatCapを計算する
inline float3 CalcMatCap(sampler2D tex, float2 uv)
{
    float3 matCap = tex2D(tex, uv);
    return matCap;
}

// 指定行列のRampTextureの色を計算する
inline float3 GetRampColor(sampler2D tex, float column, float value)
{
    float3 color = tex2D(tex, float2(column, value));
    return color;
}

//==================//
// 0    : Line      //
// 1    : Sin       //
// 2    : Saw       //
// 3    : Triangle  //
// 4    : Square    //
//==================//
float Wave(int waveMode, float waveSpeed)
{
    float speed = _Time.y * waveSpeed;
    float wave = 0.;
    if(waveMode == 0)    wave = 1.;
    if(waveMode == 1)    wave = (sin(speed * TA_PI) + 1.) * .5;
    if(waveMode == 2)    wave = frac(speed * .5 + .5);
    if(waveMode == 3)    wave = abs(2. * frac(speed * .5 - .25) - 1.);
    if(waveMode == 4)    wave = step(.5, frac(speed * .5 + .5));

    return wave;
}

#endif