using System.Collections.Generic;
using UnityEngine;
using System.Collections;
using Character;
using EPrefabID = PrefabDatabase.EPrefabID;

public class CombatManager : MonoBehaviour
{
    public Arena LevelArena;
    public Camera CombatCamera;

    private List<Enemy> Enemies = new List<Enemy>();
    private List<PlayableCharacter> PlayerCharacters = new List<PlayableCharacter>();

    public int Round { get; private set; }    

    #region Event managment
    public delegate void StartCombat(List<EPrefabID> p_enemies, List<EPrefabID> p_playerParty);
    public static event StartCombat StartCombat_event;

    public delegate void EndCombat(ECombatEnd p_state);
    public static event EndCombat EndCombat_event;

    public static void FireStartCombatEvent(List<EPrefabID> p_enemies, List<EPrefabID> p_playerParty)
    {
        StartCombat_event(p_enemies, p_playerParty);
    }

    public static void FireEndCombatEvent(ECombatEnd p_state)
    {
        EndCombat_event(p_state);
    }
    #endregion

    protected void Start()
    {
        StartCombat_event += StartCombatImplementation;
        EndCombat_event += ComputeEndCombat;
    }

    protected void Update()
    {
        if (GameState.Player.IsInCombat)
        {
            // TESTING CODE
            if (Input.GetKeyDown(KeyCode.P))
            {
                PlayerCharacters[0].Attack(Enemies[0]);
            }
            if (Input.GetKeyDown(KeyCode.O))
            {
                Enemies[0].Attack(PlayerCharacters[0]);
            }
        }
    }

    public void StartCombatImplementation(List<EPrefabID> p_enemies, List<EPrefabID> p_playerParty)
    {
        Round = 0;
        GameState.Player.IsInCombat = true;

        SpawnActors(p_enemies, p_playerParty);

        // todo : enable in combat controls

    }

    // todo : make it a coroutine & animate spawn
    private void SpawnActors(List<EPrefabID> p_enemies, List<EPrefabID> p_playerParty)
    {
        // Spawn enemies
        GameObject[] spawnPointsBuffer = LevelArena.GetEnemiesSpawnPoints(p_enemies.Count);

        for (int i = 0; i < p_enemies.Count; i++)
        {
            Enemies.Add(Instantiate(PrefabDatabase.GetPrefabForID(p_enemies[i])).GetComponent<Enemy>());
            Enemies[i].gameObject.transform.position = spawnPointsBuffer[i].transform.position;
            Enemies[i].gameObject.transform.localRotation = spawnPointsBuffer[i].transform.localRotation;
            Enemies[i].GetComponent<Animator>().SetBool("InCombat", true);
        }

        // Spawn player party
        spawnPointsBuffer = LevelArena.GetPlayerPartySpawnPoints(p_playerParty.Count);

        for (int i = 0; i < p_playerParty.Count; i++)
        {
            PlayerCharacters.Add(Instantiate(PrefabDatabase.GetPrefabForID(p_playerParty[i])).GetComponent<PlayableCharacter>());
            PlayerCharacters[i].gameObject.transform.position = spawnPointsBuffer[i].transform.position;
            PlayerCharacters[i].gameObject.transform.localRotation = spawnPointsBuffer[i].transform.localRotation;
            PlayerCharacters[i].GetComponent<Animator>().SetBool("InCombat", true);
        }

        //yield return 0;
    }
    
    private void ComputeEndCombat(ECombatEnd p_state)
    {
        if (p_state == ECombatEnd.Win)
        {
            int xpWon = 0;
            for (int i = 0; i < Enemies.Count; i++)
            {
                xpWon += Enemies[i].XPGiven;
            }
            for (int i = 0; i < PlayerCharacters.Count; i++)
            {
                PlayerCharacters[i].Experience += xpWon/PlayerCharacters.Count;
            }
        }
        else if (p_state == ECombatEnd.Lose)
        {
            //todo: define lose behavior
        }
        else if (p_state == ECombatEnd.Run)
        {
            //todo: define run behavior
        }
    }

    /// <summary>
    /// Coroutine. Checks if the combat has ended every deltaCheck seconds.
    /// </summary>
    private IEnumerator CheckIsCombatOver_Coroutine()
    {
        int i = 0;
        const float deltaCheck = 0.5f;
        bool isCombatOver = false;
        while (!isCombatOver)
        {
            for (i = 0; i < Enemies.Count; i++)
            {
                if (!Enemies[i].IsAlive && (i == 0 || isCombatOver))
                {
                    isCombatOver = true;
                }
                else
                {
                    isCombatOver = false;
                }
            }
            if (isCombatOver)
            {
                EndCombat_event(ECombatEnd.Win);
                yield return 0;
            }

            for (i = 0; i < PlayerCharacters.Count; i++)
            {
                if (!PlayerCharacters[i].IsAlive && (i == 0 || isCombatOver))
                {
                    isCombatOver = true;
                }
                else
                {
                    isCombatOver = false;
                }
            }
            if (isCombatOver)
            {
                EndCombat_event(ECombatEnd.Lose);
            }

            // Wait for deltaCheck seconds before performing a new check
            yield return new WaitForSeconds(deltaCheck);
        }
    }

    public enum ECombatEnd
    {
        Win = 0,
        Lose = 1,
        Run = 2
    }
}
