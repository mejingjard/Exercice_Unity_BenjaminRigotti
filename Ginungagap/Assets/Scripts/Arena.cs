using UnityEngine;
using System.Collections;

public class Arena : MonoBehaviour
{
    public GameObject[] SpawnPoints1Enemy = new GameObject[1];
    public GameObject[] SpawnPoints2Enemy = new GameObject[2];
    public GameObject[] SpawnPoints3Enemy = new GameObject[3];
    public GameObject[] SpawnPoints4Enemy = new GameObject[4];
    public GameObject[] SpawnPoints5Enemy = new GameObject[5];
    public GameObject[] SpawnPoints6Enemy = new GameObject[6];

    public GameObject[] SpawnPoints1Characters = new GameObject[1];
    public GameObject[] SpawnPoints2Characters = new GameObject[2];
    public GameObject[] SpawnPoints3Characters = new GameObject[3];

	// Use this for initialization
	void Start () 
    {
	
	}
	
	// Update is called once per frame
	void Update () 
    {
	
	}

    /// <summary>
    /// 
    /// </summary>
    /// <param name="p_enemyCount"> 1 <= p_enemyCount <= 6 </param>
    /// <returns></returns>
    public GameObject[] GetEnemiesSpawnPoints(int p_enemyCount)
    {
        switch (p_enemyCount)
        {
            case 1:
                return SpawnPoints1Enemy;
                break;
            case 2:
                return SpawnPoints2Enemy;
                break;
            case 3:
                return SpawnPoints3Enemy;
                break;
            case 4:
                return SpawnPoints4Enemy;
                break;
            case 5:
                return SpawnPoints5Enemy;
                break;
            case 6:
                return SpawnPoints6Enemy;
                break;
        }
        DebugLogger.LogError("GetSpawnPoints was called with enemyCount = " + p_enemyCount);
        return null;
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="p_playerTeamCount"> 1 <= p_playerTeamCount <= 3 </param>
    /// <returns></returns>
    public GameObject[] GetPlayerPartySpawnPoints(int p_playerTeamCount)
    {
        switch (p_playerTeamCount)
        {
            case 1:
                return SpawnPoints1Characters;
                break;
            case 2:
                return SpawnPoints2Characters;
                break;
            case 3:
                return SpawnPoints3Characters;
                break;
        }
        DebugLogger.LogError("GetPlayerPartySpawnPoints was called with enemyCount = " + p_playerTeamCount);
        return null;
    }
}
