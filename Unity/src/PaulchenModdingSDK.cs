using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class PaulchenModdingSDK : EditorWindow
{
    //Save stuff
    //Settings
    [SerializeField] private bool showSettings = false;
    [SerializeField] private bool autoCopyMods = true; //copy the mods in the wrs mods folder
    [SerializeField] private bool askForEachBuild = true; //ask after each build for start or restart
    [SerializeField] private bool startGameOnBuild = false; //start the game on the build
    [SerializeField] private bool restartGameOnBuild = false; //restart the game on build
    //some other nice data like last build
    [SerializeField] private string selectedMod = "";
    [SerializeField] public string lastBuild = "NONE";
    [SerializeField] public string lastBuildType = "NONE";
    //paths
    [SerializeField] private string myGamesPath = (Application.platform == RuntimePlatform.WindowsPlayer || Application.platform == RuntimePlatform.WindowsEditor ? Environment.GetFolderPath(Environment.SpecialFolder.Personal) : Environment.GetFolderPath(Environment.SpecialFolder.Personal)).Replace("\\", "/") + "/My Games/WinterResortSimulator_Season2/";//the mygames path
    [SerializeField] private string appPath = (Environment.GetEnvironmentVariable("ProgramFiles(x86)") + @"\Steam\steamapps\common\Winter Resort Simulator Season 2\WinterResortSimulator_Season2.exe").Replace("\\", "/"); //the WRS application  path
    public string getAppPath() { return appPath; }
    public string getMyGamesPath() { return myGamesPath; }

    public bool isAutoCopy() { return autoCopyMods; }
    public bool getAskForEachBuild() { return askForEachBuild; }
    public bool getStartGameOnBuild() { return startGameOnBuild; }
    public bool getRestartGameOnBuild() { return restartGameOnBuild; }

    [InitializeOnLoadMethod]
    [MenuItem("Window/PaulchenModdingSDK")]
    public static void ShowWindow()
    {
        PaulchenModdingSDK window = (PaulchenModdingSDK)EditorWindow.GetWindow(typeof(PaulchenModdingSDK), false, "PaulchenModdingSDK");
    }

    private void Update()
    {

    }

    private void OnGUI()
    {
        GUILayout.Label("PaulchenModdingSDK", EditorStyles.centeredGreyMiniLabel, GUILayout.MinHeight(50.0f));

        //Buttons
        GUILayout.Label("Builds", EditorStyles.boldLabel);
        if (GUILayout.Button("Debug"))
            ModManager.BuildMods(MOD_BUILD_MODE.DEBUG);
        if (GUILayout.Button("Release"))
            ModManager.BuildMods(MOD_BUILD_MODE.RELEASE);
        GUILayout.Space(5.0f);
        GUILayout.Label("Last Build:         " + lastBuild + " / " + lastBuildType, EditorStyles.largeLabel);
        GUILayout.Space(10.0f);


        //WRS
        GUILayout.Label("WinterResortSimulator", EditorStyles.boldLabel);
        if (GUILayout.Button("Start"))
            WinterResortSimulatorManager.LaunchWRS();
        if (GUILayout.Button("Restart"))
            WinterResortSimulatorManager.RestartWRS();
        if (GUILayout.Button("Show Log"))
            WinterResortSimulatorManager.OpenLog();
        GUILayout.Space(10.0f);

        //Mods
        GUILayout.Label("Mods", EditorStyles.boldLabel);
        GUILayout.Label("Active Mods:", EditorStyles.largeLabel);

        foreach (string modName in AssetDatabase.GetAllAssetBundleNames())
        {
            if (GUILayout.Button(modName, EditorStyles.toolbarButton))
            {
                if (modName == selectedMod)
                    selectedMod = string.Empty;
                else
                    selectedMod = modName;
            }
        }
        if (selectedMod != string.Empty)
        {
            GUILayout.BeginHorizontal();
            GUILayout.Label("Selected Mod: " + selectedMod, EditorStyles.largeLabel);
            GUILayout.EndHorizontal();
            GUILayout.BeginHorizontal();
            if (GUILayout.Button("Delete AssetBundle"))
            {
                AssetDatabase.RemoveAssetBundleName(selectedMod, true);
                selectedMod = string.Empty;
            }
            GUILayout.EndHorizontal();
        }
        GUILayout.Space(10.0f);

        //Mod Loader
        GUILayout.Label("PaulchenModdingSDK", EditorStyles.boldLabel);
        showSettings = EditorGUILayout.Foldout(showSettings, "Settings", EditorStyles.foldout);
        if (showSettings) //hide the settings stuff
        {
            appPath = EditorGUILayout.TextField("Application Path", appPath);
            myGamesPath = EditorGUILayout.TextField("MyGames Path", myGamesPath);
            GUILayout.Space(10.0f);
            autoCopyMods = EditorGUILayout.Toggle("Auto-Copy to Mods folder", autoCopyMods);
            askForEachBuild = EditorGUILayout.Toggle("Choose for each build", askForEachBuild && !restartGameOnBuild && !startGameOnBuild);
            startGameOnBuild = EditorGUILayout.Toggle("Launch WRS on Build", startGameOnBuild && !restartGameOnBuild && !askForEachBuild);
            restartGameOnBuild = EditorGUILayout.Toggle("Restart WRS on Build", restartGameOnBuild && !startGameOnBuild && !askForEachBuild);
            GUILayout.Space(10.0f);
            if (GUILayout.Button("Reset"))
            {
                GUI.FocusControl(null); //set focus to none
                askForEachBuild = autoCopyMods = true;
                startGameOnBuild = restartGameOnBuild = false;
                appPath = (System.Environment.GetEnvironmentVariable("ProgramFiles(x86)") + @"\Steam\steamapps\common\Winter Resort Simulator Season 2\WinterResortSimulator_Season2.exe").Replace("\\", "/");
                myGamesPath = (Application.platform == RuntimePlatform.WindowsPlayer || Application.platform == RuntimePlatform.WindowsEditor ? Environment.GetFolderPath(Environment.SpecialFolder.Personal) : Environment.GetFolderPath(Environment.SpecialFolder.Personal)).Replace("\\", "/") + "/My Games/WinterResortSimulator_Season2/";
            }
            GUILayout.Space(10.0f);
        }
    }
    public static PaulchenModdingSDK getActive()
    {
        return (PaulchenModdingSDK)EditorWindow.GetWindow(typeof(PaulchenModdingSDK));
    }

    //load all the stuff
    protected void OnEnable()
    {
        var loadData = EditorPrefs.GetString("PaulchenModding", JsonUtility.ToJson(this, false));
        JsonUtility.FromJsonOverwrite(loadData, this);
    }
    //save all the stuff
    protected void OnDisable()
    {
        var saveData = JsonUtility.ToJson(this, false);
        EditorPrefs.SetString("PaulchenModding", saveData);
    }
}
