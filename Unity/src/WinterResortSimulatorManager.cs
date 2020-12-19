using System;
using System.Diagnostics;
using UnityEditor;

class WinterResortSimulatorManager
{
    public static void LaunchWRS()
    {
        if (isRunning()) return;
        try { Process.Start(PaulchenModdingSDK.getActive().getAppPath()); }
        catch (Exception e) { EditorUtility.DisplayDialog("Error", "Could not find WRS Application,\nplease check you path in the settings", "OK"); throw e; }
    }

    public static void RestartWRS()
    {
        if (isRunning())
            foreach (Process proc in getProcs())
                proc.Kill();
        LaunchWRS();

    }
    public static void OnBuildModsFinished()
    {
        if (PaulchenModdingSDK.getActive().getStartGameOnBuild())
            LaunchWRS();
        else if (PaulchenModdingSDK.getActive().getRestartGameOnBuild())
            RestartWRS();
        else
            if (isRunning() && !EditorUtility.DisplayDialog("Restart the WRS", "Shall we restart the WRS?", "No", "Yes"))
                RestartWRS();
            else if (EditorUtility.DisplayDialog("Start WRS", "Shall we launch the WRS?", "Yes", "No"))
                LaunchWRS();
    }
    public static void OpenLog()
    {
        Process.Start(PaulchenModdingSDK.getActive().getMyGamesPath() + "log.txt");
    }
    private static bool isRunning() { return getProcs().Length != 0; }
    private static Process[] getProcs() { return Process.GetProcessesByName("WinterResortSimulator_Season2"); }
}