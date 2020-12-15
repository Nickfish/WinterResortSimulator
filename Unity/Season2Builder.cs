//Made by Paul Masan (Paulchen/Raining-Cloud)
//Date: 9.12.2020
//GitHub: https://github.com/Raining-Cloud

using System;
using System.Diagnostics;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace WinterResortSimulator_ModdingSDk_Season2.EditorAddOn
{
    public class Season2Builder
    {
        [MenuItem("Season 2/Build Debug")]
        private static void BuildDebugMode()
        {
            BuildAllAssetBundles(BuildAssetBundleOptions.UncompressedAssetBundle);
        }
        [MenuItem("Season 2/Build Release")]
        private static void BuildReleaseMode()
        {
            BuildAllAssetBundles(BuildAssetBundleOptions.ChunkBasedCompression);
        }
        private static void BuildAllAssetBundles(BuildAssetBundleOptions option)
        {
            string unityMods = Environment.CurrentDirectory + "/Mods/"; //Get the Unity Mod Path
            if (!Directory.Exists(unityMods)) //Check the path
                Directory.CreateDirectory(unityMods);
            //build all the mods
            AssetBundleManifest assetBundleManifest = BuildPipeline.BuildAssetBundles(unityMods, option, (BuildTarget)5);
            UnityEngine.Debug.Log((object)"Building finished!");
            if (!EditorUtility.DisplayDialog("Copy Mods?", "Shall we copy all mods into your mod directory?\n\nAttention! Conflicting names will be overwritten.", "Yes, copy all", "No"))
                return;
            string wrsMods = (Application.platform == RuntimePlatform.WindowsPlayer || Application.platform == RuntimePlatform.WindowsEditor ? Environment.GetFolderPath(Environment.SpecialFolder.Personal) : Environment.GetFolderPath(Environment.SpecialFolder.Personal)).Replace("\\", "/") + "/My Games/WinterResortSimulator_Season2/mods/";
            if (!Directory.Exists(wrsMods))
                Directory.CreateDirectory(wrsMods);
            foreach (string allAssetBundle in assetBundleManifest.GetAllAssetBundles())
            {
                try
                {
                    //copy all the mods to the WRS
                    FileUtil.ReplaceFile(unityMods + allAssetBundle, wrsMods + allAssetBundle);
                }
                catch (Exception ex)
                {
                    EditorUtility.DisplayDialog("Error", "Could not copy mod: " + allAssetBundle + ".\n\nPlease inspect the log for further details.\n" + ex.ToString(), "OK");
                    throw ex;
                }
            }
            //check if WRS is runnin
            Process[] procs = System.Diagnostics.Process.GetProcessesByName("WinterResortSimulator_Season2");
            if (procs.Length != 0)
            {
                //lets switch this
                if (!EditorUtility.DisplayDialog("Restart the WRS", "Shall we restart the WRS?", "No", "Yes"))
                {
                    foreach (Process proc in procs)
                        proc.Kill();
                    StartWRS();
                }
                return;
            }
            //else launch the WRS
            else if (EditorUtility.DisplayDialog("Start WRS", "Shall we launch the WRS?", "Yes", "No"))
            {
                StartWRS();
            }
        }
        [MenuItem("Season 2/Start WRS")]
        private static void StartWRS()
        {
            string exePath = Environment.GetEnvironmentVariable("ProgramFiles(x86)") + @"\Steam\steamapps\common\Winter Resort Simulator Season 2\WinterResortSimulator_Season2.exe";
            try
            {
                System.Diagnostics.Process.Start(exePath);
            }
            catch
            {
                EditorUtility.DisplayDialog("Error", "Could not find WRS at:\n" + exePath, "OK");
            }
        }
        [MenuItem("Season 2/Info")]
        private static void ShowInfo()
        {
            EditorUtility.DisplayDialog("Information", "This script is made by Paul Masan\nNOT by HR Innoways!\nIf you find an Error please contact me!\n\nRELEASE:\nCompresses the Mod-File so its smaller\n\nDEBUG:\nBuilds fast without compression", "Ok");
        }
    }
}

