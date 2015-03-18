using System;
using System.Collections.Generic;
using Character;
using UnityEngine;
using System.Collections;

public class PrefabDatabase : MonoBehaviour 
{
    protected void Start()
    {
        DontDestroyOnLoad(this);
    }

    public const int EPrefabID_CharactersOffset = 501;
    public enum EPrefabID
    {
        Null = -1,

        // 0 - 500 => enemies
        GF_Bee = 0,
        GF_Owl,
        GF_Spider,

        // 501 - 1000 => characters
        Melissandre = 501,
    }

    [Serializable]
    public struct PrefabID
    {
        public EPrefabID ID;
        public GameObject Prefab;
    }

    public PrefabID[] Database;

    private static Dictionary<EPrefabID, GameObject> database = new Dictionary<EPrefabID, GameObject>(); 

    protected void Awake()
    {
        foreach (PrefabID id in Database)
        {
            if (database.ContainsKey(id.ID))
            {
                Debug.LogError("EnemyDatabase got duplicate " + id.ID + ". Skipping...");
                continue;
            }
            if (id.Prefab == null)
            {
                Debug.LogError("EnemyDatabase " + id.ID + " is null. Skipping...");
                continue;
            }
            if (id.ID == EPrefabID.Null)
            {
                Debug.LogError("Found EEnemyID.Null entry in EnemyDatabase. Skipping...");
                continue;
            }

            database.Add(id.ID, id.Prefab);
        }
    }

    public static GameObject GetPrefabForID(EPrefabID id)
    {
        if (!database.ContainsKey(id))
        {
            Debug.LogError(id + " not registered in PrefabDatabase.");
            throw new Exception(id + " not registered in PrefabDatabase.");
        }
        return database[id];
    }
}
