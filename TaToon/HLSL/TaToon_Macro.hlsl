#ifndef TA_MACRO
#define TA_MACRO

#define TA_EPS .000001
#define TA_PI 3.14159265359
#define TA_TAU 6.28318530718           // PI * 2
#define TA_DEG2RAD 0.01745329251       // PI / 180
#define TA_ROT(radian) float2x2(cos(radian), sin(radian), -sin(radian), cos(radian))
#define TA_COMPARE_EPS(n) max(n, TA_EPS)

#endif