using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace AyahaShader.TaToon
{
    /// <summary>
    /// マテリアルのインスペクターのUIを拡張する機能をまとめたクラス
    /// </summary>
    public static class TaToonCustomUI
    {
        /// <summary>
        /// 開閉可能な見出し
        /// </summary>
        /// <param name="label">見出し名</param>
        /// <param name="value">開閉</param>
        public static bool Foldout(string label, bool value)
        {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.label).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = 22;
            style.contentOffset = new Vector2(20f, -2f);

            var rect = GUILayoutUtility.GetRect(16f, 22f, style);
            GUI.Box(rect, label, style);

            var e = Event.current;

            var foldoutRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
            if (e.type == EventType.Repaint)
            {
                EditorStyles.foldout.Draw(foldoutRect, false, false, value, false);
            }

            if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition))
            {
                value = !value;
                e.Use();
            }

            return value;
        }

        /// <summary>
        /// チェックボックス付きの見出し
        /// </summary>
        /// <param name="label">見出し名</param>
        /// <param name="value">開閉</param>
        public static bool ToggleFoldout(string label, bool value)
        {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.label).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = 22;
            style.contentOffset = new Vector2(20f, -2f);

            var rect = GUILayoutUtility.GetRect(16f, 22f, style);
            GUI.Box(rect, label, style);

            var e = Event.current;

            var toggleRect = new Rect(rect.x + 4f, rect.y + 2f, 13f, 13f);
            if (e.type == EventType.Repaint)
            {
                EditorStyles.toggle.Draw(toggleRect, false, false, value, false);
            }

            if (e.type == EventType.MouseDown && rect.Contains(e.mousePosition))
            {
                value = !value;
                e.Use();
            }

            return value;
        }

        /// <summary>
        /// 見出しを付ける
        /// </summary>
        /// <param name="label">見出し名</param>
        public static void Title(string label)
        {
            var style = new GUIStyle("ShurikenModuleTitle");
            style.font = new GUIStyle(EditorStyles.label).font;
            style.border = new RectOffset(15, 7, 4, 4);
            style.fixedHeight = 22;
            style.contentOffset = new Vector2(20f, -2f);

            var rect = GUILayoutUtility.GetRect(16f, 22f, style);
            GUI.Box(rect, label, style);
        }

        /// <summary>
        /// 横線を描画する
        /// </summary>
        public static void GUIPartition()
        {
            GUI.color = Color.gray;
            GUILayout.Box("", GUILayout.Height(2), GUILayout.ExpandWidth(true));
            GUI.color = Color.white;
        }

        /// <summary>
        /// 基本情報を表示する
        /// </summary>
        public static void Information()
        {
            Title("Info");
            EditorGUI.indentLevel++;
            using (new EditorGUILayout.VerticalScope(GUI.skin.box))
            {
                using (new EditorGUILayout.HorizontalScope())
                {
                    EditorGUILayout.LabelField("Version");
                    EditorGUILayout.LabelField("Version " + TaToonInfo.GetVersion());
                }

                using (new EditorGUILayout.HorizontalScope())
                {
                    EditorGUILayout.LabelField("How to use (Japanese)");
                    if (GUILayout.Button("How to use (Japanese)"))
                    {
                        System.Diagnostics.Process.Start(TaToonInfo.GetRepositoryLink());
                    }
                }
            }
            EditorGUI.indentLevel--;
        }

        /// <summary>
        /// Emissionの周期を設定する
        /// </summary>
        /// <param name="material">マテリアル</param>
        /// <param name="materialEditor">マテリアルエディター</param>
        /// <param name="selectFlicker">どの点滅モードを選択してるか</param>
        /// <param name="selectFlickerPropName">点滅モードのプロパティ名</param>
        /// <param name="frequencyProp">周波数のプロパティ</param>
        public static void FlickerModeToolbar(Material material, MaterialEditor materialEditor, int selectFlicker, string selectFlickerPropName, MaterialProperty frequencyProp)
        {
            using (new EditorGUILayout.VerticalScope())
            {
                selectFlicker = material.GetInt(selectFlickerPropName);

                EditorGUILayout.LabelField("FlickerMode");
                Texture[] textures = new Texture[5];
                textures[(int)TaToonFlickerMode.Line] = AssetDatabase.LoadAssetAtPath<Texture>("Assets/TaToon/GUIImage/Line.png");
                textures[(int)TaToonFlickerMode.Sin] = AssetDatabase.LoadAssetAtPath<Texture>("Assets/TaToon/GUIImage/Sin.png");
                textures[(int)TaToonFlickerMode.Saw] = AssetDatabase.LoadAssetAtPath<Texture>("Assets/TaToon/GUIImage/Saw.png");
                textures[(int)TaToonFlickerMode.Triangle] = AssetDatabase.LoadAssetAtPath<Texture>("Assets/TaToon/GUIImage/Triangle.png");
                textures[(int)TaToonFlickerMode.Square] = AssetDatabase.LoadAssetAtPath<Texture>("Assets/TaToon/GUIImage/Square.png");
                selectFlicker = GUILayout.Toolbar(selectFlicker, textures, GUILayout.Height(30));
                material.SetInt(selectFlickerPropName, selectFlicker);

                if (selectFlicker != (int)TaToonFlickerMode.Line)
                {
                    materialEditor.ShaderProperty(frequencyProp, new GUIContent("Frequency"));
                }
            }
        }
    }
}
