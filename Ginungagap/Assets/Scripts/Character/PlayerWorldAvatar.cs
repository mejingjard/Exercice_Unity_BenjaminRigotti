using System.Collections.Generic;
using Controller;
using UnityEngine;
using System.Collections;
using EPrefabID = PrefabDatabase.EPrefabID;

namespace Character
{
    [RequireComponent(typeof(Animator))]
    [RequireComponent(typeof(CharacterController))]
    [RequireComponent(typeof(ThirdPersonController))]
    public class PlayerWorldAvatar : MonoBehaviour
    {
        private Animator animatorInstance;
        private ThirdPersonController thirdPersonControllerInstance;

        private BoxCollider interactionCollider;

        public GameObject singleHandedWeaponHolder;
        public GameObject shieldHolder;
        public GameObject backHolder;
        public GameObject leftHipWeaponHolder;

        // Use this for initialization
        void Start()
        {
            animatorInstance = gameObject.GetComponent<Animator>();
            thirdPersonControllerInstance = gameObject.GetComponent<ThirdPersonController>();

            singleHandedWeaponHolder.SetActive(false);
            shieldHolder.SetActive(false);
            backHolder.SetActive(true);
            leftHipWeaponHolder.SetActive(true);

            // Interaction collider detector setup
            GameObject interactionColliderGO = new GameObject("Interaction Collider");
            interactionColliderGO.transform.parent = gameObject.transform;
            interactionColliderGO.transform.localPosition = new Vector3(0.0f, 3.0f, 1.0f);

            interactionCollider = interactionColliderGO.AddComponent<BoxCollider>();
            interactionCollider.center = Vector3.zero;
            interactionCollider.size = new Vector3(2.0f, 5.0f, 2.0f);
            interactionCollider.isTrigger = true;

            CombatManager.StartCombat_event += EnterCombat;
        }

        // Update is called once per frame
        void Update()
        {

        }

        private void EnterCombat(List<EPrefabID> enemies, List<EPrefabID> playerTeam)
        {
            animatorInstance.SetBool("InBattle", true);
            DrawWeapons();
        }

        public void DrawWeapons()
        {
            backHolder.SetActive(false);
            leftHipWeaponHolder.SetActive(false);
            singleHandedWeaponHolder.SetActive(true);
            shieldHolder.SetActive(true);
        }

        public void SheatheWeapons()
        {
            singleHandedWeaponHolder.SetActive(false);
            shieldHolder.SetActive(false);
            backHolder.SetActive(true);
            leftHipWeaponHolder.SetActive(true);
        }

    }
}

