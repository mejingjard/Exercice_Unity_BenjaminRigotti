using System.Collections.Generic;
using UI;
using UnityEngine;
using System.Collections;
using Character;
using EPrefabID = PrefabDatabase.EPrefabID;

[RequireComponent(typeof(GameState))]
[RequireComponent(typeof(CombatManager))]
[RequireComponent(typeof(UIManager))]
public class GameLogic : MonoBehaviour
{
    public bool IsDebugEnabled = true;

    public PlayableCharacter Player;
    public Camera ThirdPersonCamera;
    public Camera BattleCamera;

    private GameState gameState;
    private CombatManager combatManager;
    private UIManager uiManager;

    protected void Start ()
	{
	    if (ThirdPersonCamera == null)
	    {
	        ThirdPersonCamera = Camera.main;
	    }

        BattleCamera.gameObject.SetActive(false);

        gameState = gameObject.GetComponent<GameState>();
        combatManager = gameObject.GetComponent<CombatManager>();
        uiManager = gameObject.GetComponent<UIManager>();

        CombatManager.StartCombat_event += EnterCombat;

        // DEBUG INIT OF GAME STATE todo delete when finished
        GameState.InitDebugState();
	}
	
    protected void Update() 
    {

	}

    public void EnterCombat(List<EPrefabID> enemies, List<EPrefabID> playerTeam)
    {
        if (IsDebugEnabled)
        {
            DebugLogger.LogMessage("Entering combat...");
        }

        GameState.Player.IsInCombat = true;
        StartCoroutine(EnterCombat_Coroutine(enemies, playerTeam));
        //ThirdPersonCamera.SetActive(false);
        //BattleCamera.SetActive(true);

    }

    public IEnumerator EnterCombat_Coroutine(List<EPrefabID> enemies, List<EPrefabID> playerTeam)
    {
        //fadeManagerInstance.StartFadeToBlack(0.5f);
        //yield return new WaitForSeconds(0.5f);
        BattleCamera.gameObject.SetActive(true);
        
        ThirdPersonCamera.gameObject.SetActive(false);
        //fadeManagerInstance.StartFadeToClear(0.5f);

        uiManager.DisplayCombatUI();

        yield return 0;
    }
}
