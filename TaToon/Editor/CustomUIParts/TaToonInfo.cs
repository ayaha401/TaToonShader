using UnityEngine;

namespace AyahaShader.TaToon
{
    public class TaToonInfo : MonoBehaviour
    {
        private static string version = "0.0.1";
        private static string repositoryLink = "https://github.com/ayaha401/TaToonShader";

        /// <summary>
        /// 現在のバージョン
        /// </summary>
        public static string GetVersion()
        {
            return version;
        }

        /// <summary>
        /// リポジトリへのリンク
        /// </summary>
        public static string GetRepositoryLink()
        {
            return repositoryLink;
        }
    }
}
