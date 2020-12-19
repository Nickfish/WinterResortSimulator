using UnityEditor;
using UnityEngine;

class PaulchenModdingMenu
{

    [MenuItem("PaulchenModdingSDK/Open Menu")]
    public static void ShowWindow()
    {
        PaulchenModdingSDK.ShowWindow();
    }

    [MenuItem("PaulchenModdingSDK/Build/Debug")]
    public static void BuildDebug()
    {
        ModManager.BuildMods(MOD_BUILD_MODE.DEBUG);
    }

    [MenuItem("PaulchenModdingSDK/Build/Release")]
    public static void BuildRelease()
    {
        ModManager.BuildMods(MOD_BUILD_MODE.RELEASE);
    }

    [MenuItem("PaulchenModdingSDK/Start WRS")]
    public static void StartWRS()
    {
        WinterResortSimulatorManager.LaunchWRS();
    }

    [MenuItem("PaulchenModdingSDK/Credits")]
    public static void Credits()
    {
        System.Diagnostics.Process.Start("https://github.com/Raining-Cloud");
    }
}
