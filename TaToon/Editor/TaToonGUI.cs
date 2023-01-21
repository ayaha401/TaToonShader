using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace AyahaShader.TaToon
{
    public class TaToonGUI : ShaderGUI
    {
        // MainColor
        private MaterialProperty mainTex;
        private MaterialProperty alphaMask;
        private MaterialProperty color;
        private MaterialProperty useVertCol;

        // SubTexture
        private bool useSubTexToggleFoldout;
        private MaterialProperty subTex;
        private MaterialProperty subTexColor;
        private MaterialProperty subTexBumpMap;
        private MaterialProperty subTexBumpScale;
        private MaterialProperty subTexMode;
        private MaterialProperty subTexColorMode;
        private MaterialProperty subTexColorChange;
        private MaterialProperty subTexMask;
        private MaterialProperty subTexMaskIntensity;
        private bool subTexScrollToggleFoldout;
        private MaterialProperty subTexScrollX;
        private MaterialProperty subTexScrollY;
        private bool useSubTexEmission;
        private MaterialProperty subTexEmissionColor;
        private MaterialProperty subTexEmissionMaskIntensity;
        private int subTexEmissionFlickerMode;
        private MaterialProperty subTexEmissionFrequency;
        private bool subTexAdvancedSettingToggleFoldout;
        private MaterialProperty subTexCullingMode;
        private MaterialProperty subTexScrollSpeed;

        // Decal
        private bool useDecalToggleFoldout;
        private MaterialProperty decalTex;
        private MaterialProperty decalBumpMap;
        private MaterialProperty decalBumpScale;
        private MaterialProperty decalMode;
        private bool useDecalAnimationToggleFoldout;
        private MaterialProperty frameNum;
        private MaterialProperty decalAnimationSpeed;
        private MaterialProperty decalPosX;
        private MaterialProperty decalPosY;
        private MaterialProperty decalSizeX;
        private MaterialProperty decalSizeY;
        private MaterialProperty decalRot;
        private bool useDecalEmissionToggleFoldout;
        private MaterialProperty decalEmissionColor;
        private int decalEmissionFlickerMode;
        private MaterialProperty decalEmissionFrequency;

        // Normal
        private MaterialProperty bumpMap;
        private MaterialProperty bumpScale;

        // Shading
        private MaterialProperty shadeMask;
        private MaterialProperty shadeColor;
        private MaterialProperty shadeBorder;
        private MaterialProperty shadeBorderWidth;
        private MaterialProperty brightness;
        private bool shadingAdvancedSettingFoldout;
        private MaterialProperty minBrightness;

        // Emission
        private bool useEmissionToggleFoldout;
        private MaterialProperty emissionMask;
        private MaterialProperty emissionColor;
        private int emissionFlickerMode;
        private MaterialProperty emissionFrequency;

        // Rimlight
        private bool useRimToggleFoldout;
        private MaterialProperty rimMask;
        private MaterialProperty rimColor;
        private MaterialProperty rimPower;
        private MaterialProperty rimWidth;

        // Reflection
        private bool useReflectToggleFoldout;
        private MaterialProperty reflectMask;
        private MaterialProperty smoothness;
        private MaterialProperty specularPower;
        private MaterialProperty matCapTex;

        // Outline
        private bool useOutlineToggleFoldout;
        private MaterialProperty outlineMask;
        private MaterialProperty outlineColor;
        private MaterialProperty outlineWidth;
        private bool outlineAdvancedSettingFoldout;
        private MaterialProperty useLightColor;

        // OtherSetting
        private bool otherSettingFoldout;
        private MaterialProperty cullingMode;
        private MaterialProperty enableZWrite;
        private MaterialProperty pointLightLimit;
        private MaterialProperty rampTex;

        public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] prop)
        {
            var material = (Material)materialEditor.target;
            FindProperties(prop);

            // 基本情報を描画
            TaToonCustomUI.Information();

            TaToonCustomUI.GUIPartition();

            // 初期状態のGUIを表示させる
            //base.OnGUI(materialEditor, prop);

            // Main
            TaToonCustomUI.Title("Main");
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                materialEditor.TexturePropertySingleLine(new GUIContent("Main Texture"), mainTex, color);
                if(alphaMask != null)
                {
                    materialEditor.TexturePropertySingleLine(new GUIContent("AlphaMask"), alphaMask);
                }
                materialEditor.ShaderProperty(useVertCol, new GUIContent("Use Vertex Color"));
            }

            // Normal
            TaToonCustomUI.Title("Normal");
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                materialEditor.TexturePropertySingleLine(new GUIContent("Normal Map"), bumpMap, bumpScale);
            }
            

            // Shading
            TaToonCustomUI.Title("Shading");
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                materialEditor.TexturePropertySingleLine(new GUIContent("Mask"), shadeMask);

                EditorGUILayout.LabelField("Shade", EditorStyles.boldLabel);
                materialEditor.ShaderProperty(shadeColor, "Shade Color");
                materialEditor.ShaderProperty(shadeBorder, "Border");
                materialEditor.ShaderProperty(shadeBorderWidth, "Border Width");

                EditorGUILayout.LabelField("Bright", EditorStyles.boldLabel);
                materialEditor.ShaderProperty(brightness, "Brightness");

                shadingAdvancedSettingFoldout = EditorGUILayout.Foldout(shadingAdvancedSettingFoldout, "AdvancedSetting", true);
                if (shadingAdvancedSettingFoldout)
                {
                    materialEditor.ShaderProperty(minBrightness, "Min Brightness");
                }
            }

            // SubTexture
            if (material.GetInt("_UseSubTex") == 1) useSubTexToggleFoldout = true;
            useSubTexToggleFoldout = TaToonCustomUI.ToggleFoldout("SubTexture", useSubTexToggleFoldout);
            if(useSubTexToggleFoldout)
            {
                material.SetInt("_UseSubTex", 1);
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(subTexMode, new GUIContent("SubTexture Mode"));
                materialEditor.TexturePropertySingleLine(new GUIContent("Sub Texture"), subTex);
                materialEditor.TexturePropertySingleLine(new GUIContent("NormalMap"), subTexBumpMap, subTexBumpScale);
                materialEditor.TexturePropertySingleLine(new GUIContent("Mask"), subTexMask, subTexMaskIntensity);

                EditorGUILayout.LabelField("SubTexColor", EditorStyles.boldLabel);
                using (new EditorGUILayout.HorizontalScope())
                {
                    materialEditor.ShaderProperty(subTexColor, new GUIContent("Color"));
                    materialEditor.ShaderProperty(subTexColorMode, "");
                }
                materialEditor.ShaderProperty(subTexColorChange, "Color Change");

                subTexScrollToggleFoldout = EditorGUILayout.Foldout(subTexScrollToggleFoldout, "UV Scroll", true);
                if(subTexScrollToggleFoldout)
                {
                    materialEditor.ShaderProperty(subTexScrollX, "ScrollX");
                    materialEditor.ShaderProperty(subTexScrollY, "ScrollY");
                }

                if (material.GetInt("_UseSubTexEmission") == 1) useSubTexEmission = true;
                useSubTexEmission = EditorGUILayout.ToggleLeft("Use Emission", useSubTexEmission);
                if(useSubTexEmission)
                {
                    material.SetInt("_UseSubTexEmission", 1);
                    materialEditor.ShaderProperty(subTexEmissionColor, "Emission Color");
                    materialEditor.ShaderProperty(subTexEmissionMaskIntensity, "Emission Mask Intensity");
                    TaToonCustomUI.FlickerModeToolbar(material, materialEditor, subTexEmissionFlickerMode, "_SubTexEmissionFlickerMode", subTexEmissionFrequency);
                }
                else
                {
                    material.SetInt("_UseSubTexEmission", 0);
                }

                subTexAdvancedSettingToggleFoldout = EditorGUILayout.Foldout(subTexAdvancedSettingToggleFoldout, "AdvancedSetting", true);
                if(subTexAdvancedSettingToggleFoldout)
                {
                    materialEditor.ShaderProperty(subTexCullingMode, "Culling Mode");
                    materialEditor.ShaderProperty(subTexScrollSpeed, "Scroll Speed");
                }
                EditorGUI.indentLevel--;
            }
            else
            {
                material.SetInt("_UseSubTex", 0);
            }

            // Decal
            if (material.GetInt("_UseDecal") == 1) useDecalToggleFoldout = true;
            useDecalToggleFoldout = TaToonCustomUI.ToggleFoldout("Decal", useDecalToggleFoldout);
            if(useDecalToggleFoldout)
            {
                material.SetInt("_UseDecal", 1);
                EditorGUI.indentLevel++;
                materialEditor.ShaderProperty(decalMode, "Decal Mode");
                materialEditor.TexturePropertySingleLine(new GUIContent("Decal Texture"), decalTex);
                materialEditor.TexturePropertySingleLine(new GUIContent("Normal"), decalBumpMap, decalBumpScale);

                if (material.GetInt("_UseDecalAnimation") == 1) useDecalAnimationToggleFoldout = true;
                useDecalAnimationToggleFoldout = EditorGUILayout.ToggleLeft("Use Decal Animation", useDecalAnimationToggleFoldout);
                if(useDecalAnimationToggleFoldout)
                {
                    material.SetInt("_UseDecalAnimation", 1);
                    materialEditor.ShaderProperty(frameNum, "FrameNum");
                    materialEditor.ShaderProperty(decalAnimationSpeed, "Animation Speed");
                    EditorGUILayout.LabelField("Decal Transform", EditorStyles.boldLabel);
                    materialEditor.ShaderProperty(decalPosX, "Decal PosX");
                    materialEditor.ShaderProperty(decalPosY, "Decal PosY");
                    materialEditor.ShaderProperty(decalSizeX, "Decal SizeX");
                    materialEditor.ShaderProperty(decalSizeY, "Decal SizeY");
                    materialEditor.ShaderProperty(decalRot, "Decal Rotation");
                }
                else
                {
                    material.SetInt("_UseDecalAnimation", 0);
                }

                if (material.GetInt("_UseDecalEmission") == 1) useDecalEmissionToggleFoldout = true;
                useDecalEmissionToggleFoldout = EditorGUILayout.ToggleLeft("Use Decal Emission", useDecalEmissionToggleFoldout);
                if(useDecalEmissionToggleFoldout)
                {
                    material.SetInt("_UseDecalEmission", 1);
                    materialEditor.ShaderProperty(decalEmissionColor, "Emission Color");
                    TaToonCustomUI.FlickerModeToolbar(material, materialEditor, decalEmissionFlickerMode, "_DecalEmissionFlickerMode", decalEmissionFrequency);
                }
                else
                {
                    material.SetInt("_UseDecalEmission", 0);
                }

                EditorGUI.indentLevel--;
            }
            else
            {
                material.SetInt("_UseDecal", 0);
            }

            // Emission
            if (material.GetInt("_UseEmission") == 1) useEmissionToggleFoldout = true;
            useEmissionToggleFoldout = TaToonCustomUI.ToggleFoldout("Emission", useEmissionToggleFoldout);
            if(useEmissionToggleFoldout)
            {
                material.SetInt("_UseEmission", 1);
                materialEditor.TexturePropertySingleLine(new GUIContent("Mask"), emissionMask);
                materialEditor.ShaderProperty(emissionColor, "Emisson Color");
                TaToonCustomUI.FlickerModeToolbar(material, materialEditor, emissionFlickerMode, "_EmissionFlickerMode", emissionFrequency);
            }
            else
            {
                material.SetInt("_UseEmission", 0);
            }

            // Rimlight
            if (material.GetInt("_UseRim") == 1) useRimToggleFoldout = true;
            useRimToggleFoldout = TaToonCustomUI.ToggleFoldout("Rimlight", useRimToggleFoldout);
            if(useRimToggleFoldout)
            {
                material.SetInt("_UseRim", 1);
                materialEditor.TexturePropertySingleLine(new GUIContent("Mask"), rimMask);
                materialEditor.ShaderProperty(rimColor, "Rimlight Color");
                materialEditor.ShaderProperty(rimPower, "Rimlight Power");
                materialEditor.ShaderProperty(rimWidth, "Rimlight Width");
            }
            else
            {
                material.SetInt("_UseRim", 0);
            }

            // Reflection
            if (material.GetInt("_UseReflect") == 1) useReflectToggleFoldout = true;
            useReflectToggleFoldout = TaToonCustomUI.ToggleFoldout("Reflection", useReflectToggleFoldout);
            if(useReflectToggleFoldout)
            {
                material.SetInt("_UseReflect", 1);
                materialEditor.TexturePropertySingleLine(new GUIContent("Mask"), reflectMask);
                materialEditor.ShaderProperty(smoothness, "Smoothness");
                materialEditor.ShaderProperty(specularPower, "SpecularPower");
                EditorGUILayout.LabelField("MatCap", EditorStyles.boldLabel);
                materialEditor.TexturePropertySingleLine(new GUIContent("MatCap Texture"), matCapTex);
            }
            else
            {
                material.SetInt("_UseReflect", 0);
            }

            // Outline
            if (material.GetInt("_UseOutline") == 1) useOutlineToggleFoldout = true;
            useOutlineToggleFoldout = TaToonCustomUI.ToggleFoldout("Outline", useOutlineToggleFoldout);
            if(useOutlineToggleFoldout)
            {
                material.SetInt("_UseOutline", 1);
                materialEditor.TexturePropertySingleLine(new GUIContent("Mask"), outlineMask);
                materialEditor.ShaderProperty(outlineColor, "Outline Color");
                materialEditor.ShaderProperty(outlineWidth, "Outline Width");
                outlineAdvancedSettingFoldout = EditorGUILayout.Foldout(outlineAdvancedSettingFoldout, "AdvancedSetting", true);
                if(outlineAdvancedSettingFoldout)
                {
                    materialEditor.ShaderProperty(useLightColor, "Use Light Color");
                }
            }
            else
            {
                material.SetInt("_UseOutline", 0);
            }

            otherSettingFoldout = TaToonCustomUI.Foldout("OtherSetting", otherSettingFoldout);
            if(otherSettingFoldout)
            {
                materialEditor.ShaderProperty(cullingMode, "CullingMode");
                materialEditor.ShaderProperty(enableZWrite, "EnableZWrite");
                materialEditor.ShaderProperty(pointLightLimit, "PointLight Limit");
                materialEditor.TexturePropertySingleLine(new GUIContent("Ramp Texture"), rampTex);
                EditorGUILayout.HelpBox("未実装", MessageType.Warning);
            }
        }

        private void FindProperties(MaterialProperty[] prop)
        {
            // MainColor
            mainTex = FindProperty("_MainTex", prop, false);
            alphaMask = FindProperty("_AlphaMask", prop, false);
            color = FindProperty("_Color", prop, false);
            useVertCol = FindProperty("_UseVertCol", prop, false);

            // SubTex
            subTex = FindProperty("_SubTex", prop, false);
            subTexColor = FindProperty("_SubTexColor", prop, false);
            subTexBumpMap = FindProperty("_SubTexBumpMap", prop, false);
            subTexBumpScale = FindProperty("_SubTexBumpScale", prop, false);
            subTexMode = FindProperty("_SubTexMode", prop, false);
            subTexColorMode = FindProperty("_SubTexColorMode", prop, false);
            subTexColorChange = FindProperty("_SubTexColorChange", prop, false);
            subTexMask = FindProperty("_SubTexMask", prop, false);
            subTexMaskIntensity = FindProperty("_SubTexMaskIntensity", prop, false);
            subTexScrollX = FindProperty("_SubTexScrollX", prop, false);
            subTexScrollY = FindProperty("_SubTexScrollY", prop, false);
            subTexEmissionColor = FindProperty("_SubTexEmissionColor", prop, false);
            subTexEmissionMaskIntensity = FindProperty("_SubTexEmissionMaskIntensity", prop, false);
            subTexEmissionFrequency = FindProperty("_SubTexEmissionFrequency", prop, false);
            subTexCullingMode = FindProperty("_SubTexCullingMode", prop, false);
            subTexScrollSpeed = FindProperty("_SubTexScrollSpeed", prop, false);

            // Decal
            decalTex = FindProperty("_DecalTex", prop, false);
            decalBumpMap = FindProperty("_DecalBumpMap", prop, false);
            decalBumpScale = FindProperty("_DecalBumpScale", prop, false);
            decalMode = FindProperty("_DecalMode", prop, false);
            frameNum = FindProperty("_FrameNum", prop, false);
            decalAnimationSpeed = FindProperty("_DecalAnimationSpeed", prop, false);
            decalPosX = FindProperty("_DecalPosX", prop, false);
            decalPosY = FindProperty("_DecalPosY", prop, false);
            decalSizeX = FindProperty("_DecalSizeX", prop, false);
            decalSizeY = FindProperty("_DecalSizeY", prop, false);
            decalRot = FindProperty("_DecalRot", prop, false);
            decalEmissionColor = FindProperty("_DecalEmissionColor", prop, false);
            decalEmissionFrequency = FindProperty("_DecalEmissionFrequency", prop, false);

            // Normal
            bumpMap = FindProperty("_BumpMap", prop, false);
            bumpScale = FindProperty("_BumpScale", prop, false);

            // Shading
            shadeMask = FindProperty("_ShadeMask", prop, false);
            shadeColor = FindProperty("_ShadeColor", prop, false);
            shadeBorder = FindProperty("_ShadeBorder", prop, false);
            shadeBorderWidth = FindProperty("_ShadeBorderWidth", prop, false);
            brightness = FindProperty("_Brightness", prop, false);
            minBrightness = FindProperty("_MinBrightness", prop, false);

            // Emission
            emissionMask = FindProperty("_EmissionMask", prop, false);
            emissionColor = FindProperty("_EmissionColor", prop, false);
            emissionFrequency = FindProperty("_EmissionFrequency", prop, false);

            // Rimlight
            rimMask = FindProperty("_RimMask", prop, false);
            rimColor = FindProperty("_RimColor", prop, false);
            rimPower = FindProperty("_RimPower", prop, false);
            rimWidth = FindProperty("_RimWidth", prop, false);

            // Reflection
            reflectMask = FindProperty("_ReflectMask", prop, false);
            smoothness = FindProperty("_Smoothness", prop, false);
            specularPower = FindProperty("_SpecularPower", prop, false);
            matCapTex = FindProperty("_MatCapTex", prop, false);

            // Outline
            outlineMask = FindProperty("_OutlineMask", prop, false);
            outlineColor = FindProperty("_OutlineColor", prop, false);
            outlineWidth = FindProperty("_OutlineWidth", prop, false);
            useLightColor = FindProperty("_UseLightColor", prop, false);

            // OtherSetting
            cullingMode = FindProperty("_CullingMode", prop, false);
            enableZWrite = FindProperty("_EnableZWrite", prop, false);
            pointLightLimit = FindProperty("_PointLightLimit", prop, false);
            rampTex = FindProperty("_RampTex", prop, false);
        }
    }
}
