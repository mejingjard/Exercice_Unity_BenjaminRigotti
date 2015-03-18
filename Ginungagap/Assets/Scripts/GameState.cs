using System.Collections;
using System.Collections.Generic;
using Character;
using UnityEngine;

public sealed class GameState : MonoBehaviour
{
    public class Player
    {
        public static bool IsInCombat;
        public static bool IsInMenu;
        public static PlayableCharactersID[] PlayerParty = new PlayableCharactersID[3];

        public class Characters
        {
            public static Melissandre Melissandre;
        }
    }

    public class Enemy
    {
        
    }

    public class Achievements
    {
        
    }

    public class Progression
    {
        
    }


    public static void InitDebugState()
    {
        // Player init
        Player.IsInCombat = false;
        Player.IsInMenu = false;
        Player.PlayerParty[0] = PlayableCharactersID.Melissandre;
        Player.PlayerParty[1] = PlayableCharactersID.Null;
        Player.PlayerParty[2] = PlayableCharactersID.Null;

        // Enemy init

        // Achievments init

        // Progression init
    }



    public static List<PlayableCharactersID> GetPlayerPartyIDs()
    {
        List<PlayableCharactersID> list = new List<PlayableCharactersID>();
        foreach (PlayableCharactersID playableCharactersId in Player.PlayerParty)
        {
            if (playableCharactersId != PlayableCharactersID.Null)
            {
                list.Add(playableCharactersId);
            }
        }

        if (list.Count == 0)
        {
            DebugLogger.LogError("GetPlayerPartyIDs returned 0 Ids");
        }

        return list;
    }

    public static List<PrefabDatabase.EPrefabID> GetPlayerPartyPrefabs()
    {
        List<PlayableCharactersID> playerPartyIds = GetPlayerPartyIDs();
        List<PrefabDatabase.EPrefabID> prefabsIDs = new List<PrefabDatabase.EPrefabID>();

        foreach (PlayableCharactersID characterId in playerPartyIds)
        {
            prefabsIDs.Add((PrefabDatabase.EPrefabID)characterId);
        }
        return prefabsIDs;
    }
}