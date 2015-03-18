using UnityEngine;
using System.Collections;

public class NewGame_Button : MonoBehaviour 
{

    public void NewGame()
    {
        Application.LoadLevel("1_GuardianVillage");
    }

}
