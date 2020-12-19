using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using UnityEditor;
using UnityEngine;

public enum MOD_BUILD_MODE
{
    DEBUG = BuildAssetBundleOptions.UncompressedAssetBundle,
    RELEASE = BuildAssetBundleOptions.ChunkBasedCompression,
};
public struct TypeFileEnding
{
    public TypeFileEnding(string t, string f) { Type = t; FileEnding = f; }
    public string Type { get; }
    public string FileEnding { get; }
}
public class ModManager
{
    private List<TypeFileEnding> datatable = new List<TypeFileEnding> {
        new TypeFileEnding("UnityEngine.Material", ".mat"),
        new TypeFileEnding("UnityEngine.Texture2D", ".png"),
        new TypeFileEnding("UnityEditor.Animations.AnimatorController", ".anim"),
        new TypeFileEnding("UnityEngine.AudioClip", ".mp3"),
        new TypeFileEnding("UnityEngine.GameObject", ".mat"),
        new TypeFileEnding("UnityEngine.Mesh", ".mat"),
        new TypeFileEnding("UnityEngine.AnimationClip", ".mat"),
        new TypeFileEnding("LuaAsset", ".lua"),
        new TypeFileEnding("UnityEngine.Sprite", ".mat"),
    };

    public static void BuildMods(MOD_BUILD_MODE mode)
    {
        string unityMods = Environment.CurrentDirectory + "/Mods/";
        string wrsMods = PaulchenModdingSDK.getActive().getMyGamesPath() + "mods/";

        if (!Directory.Exists(unityMods))
            Directory.CreateDirectory(unityMods);
        AssetBundleManifest assetBundleManifest = BuildPipeline.BuildAssetBundles(unityMods, (BuildAssetBundleOptions)mode, BuildTarget.StandaloneWindows);
        UnityEngine.Debug.Log("Finished Building");
        if (!PaulchenModdingSDK.getActive().isAutoCopy())
            return;
        if (!Directory.Exists(wrsMods))
            Directory.CreateDirectory(wrsMods);
        foreach (string assetBndl in assetBundleManifest.GetAllAssetBundles())
            try { FileUtil.ReplaceFile(unityMods + assetBndl, wrsMods + assetBndl); }
            catch (Exception e) { EditorUtility.DisplayDialog("ERROR", "Could't copy the mod: " + assetBndl + "\n Check mannually for any errors", "Ok"); throw e; }

        //update the stats
        PaulchenModdingSDK.getActive().lastBuild = DateTime.Now.ToString("dd.MM.yy HH:mm") + " Uhr";
        PaulchenModdingSDK.getActive().lastBuildType = mode.ToString();

        WinterResortSimulatorManager.OnBuildModsFinished();//Maybe before buildings mods to save time
    }
}
