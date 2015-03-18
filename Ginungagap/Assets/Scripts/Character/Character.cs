using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.Collections;
using Utilities;
using Random = UnityEngine.Random;
using EPrefabID = PrefabDatabase.EPrefabID;

namespace Character
{
    /// <summary>
    /// 
    /// </summary>
    public abstract class Character : MonoBehaviour
    {
        public enum ERace
        {
            Satyr = 0,
            NatureAvatar = 1
        }

        public enum EClass
        {
            Guardian = 0,
        }

        public enum ESize
        {
            Small = 0,
            Normal = 1,
            Big = 2
        }

        public bool IsDebugEnabled = true;

        public string Name;
        public string Description;
        public ESize Size = ESize.Normal;

        public int Level = 1;

        public int MaxHP = 50;
        public int CurrentHP = 50;

        public int MaxMP = 0;
        public int CurrentMP = 0;

        public int Strenght = 10;
        public int Vitality = 10;
        public int Agility = 10;
        public int Dexterity = 10;
        public int Intelligence = 10;

        public float HitBonus;
        public float CounterBonus;
        public float CriticalBonus;
        public float BlockBonus;
        public float EscapeBonus;
        public float SpeedBonus;
        public float IteamStealBonus;
        public float MoneyStealBonus;

        public float MoveSpeed;

        public bool IsAlive
        {
            get { return CurrentHP > 0; }
        }

        public abstract void Attack(Character p_target);
        public abstract void Defend();
        public abstract void CounterAttack();
        public abstract void MagicAttack();
        public abstract void Hit(int p_damages);
    }

    /// <summary>
    /// 
    /// </summary>
    public abstract class NonPlayableCharacter : Character
    {

    }

    /// <summary>
    /// Defines a character that can be fought
    /// </summary>
    public abstract class FightableCharacter : NonPlayableCharacter, IBoardCharacter
    {
        protected Animator animator;

        public int MoneyGiven;
        public int XPGiven;

        // Movement
        public Vector3 targetPoint;
        private Vector3 moveDirection = Vector3.zero;
        private Vector3 moveVector = Vector3.zero;
        private Vector3 lastMoveVector = Vector3.zero;
        private float verticalSpeed = 0.0f;
        protected float moveSpeed = 0.0f;
        protected float lastMoveSpeed = 0.0f;

        protected const float WalkSpeed = 8.0f;
        protected const float SprintSpeed = 20.0f;
        protected const float SpeedSmoothing = 5.0f;


        public float CombatColliderRadius = 1.0f;

        private SphereCollider combatSphereCollider;

        public abstract void MoveTo(Vector3 p_point);

        protected void Start()
        {
            GameObject combatSphereColliderGO = new GameObject("Combat Sphere Collider");
            combatSphereColliderGO.transform.parent = gameObject.transform;
            combatSphereColliderGO.transform.localPosition = Vector3.zero;

            combatSphereCollider = combatSphereColliderGO.AddComponent<SphereCollider>();
            combatSphereCollider.isTrigger = true;
            combatSphereCollider.radius = CombatColliderRadius;

            combatSphereColliderGO.AddComponent<CombatSphereCollider>();

            targetPoint = gameObject.transform.position;
        }

        protected void Update()
        {
            if (!(gameObject.transform.position.x.NearlyEqual(targetPoint.x, 0.1f)
                && gameObject.transform.position.z.NearlyEqual(targetPoint.z, 0.1f)))
            {
                moveDirection = Vector3.Normalize(targetPoint - transform.position);
                lastMoveSpeed = moveSpeed;

                moveSpeed = Mathf.Lerp(lastMoveSpeed, SprintSpeed, Time.deltaTime * SpeedSmoothing);

                animator.SetFloat("Speed", moveSpeed / SprintSpeed);

                lastMoveVector = moveVector;
                moveVector = moveDirection * moveSpeed + new Vector3(0, verticalSpeed, 0);
                moveVector *= Time.deltaTime;
                moveVector = Vector3.Lerp(lastMoveVector, moveVector, Time.deltaTime * SpeedSmoothing);

                moveVector.y += Physics.gravity.y * Time.deltaTime;

                Move(moveVector);
            }
            else
            {
                lastMoveSpeed = moveSpeed;
                moveSpeed = Mathf.Lerp(lastMoveSpeed, 0, Time.deltaTime * SpeedSmoothing);
                animator.SetFloat("Speed", moveSpeed / SprintSpeed);
            }
        }

        public abstract void Move(Vector3 p_motion);
        public abstract void OnEnterCombatSphere();
    }

    [RequireComponent(typeof(SphereCollider))]
    public class CombatSphereCollider : MonoBehaviour
    {
        public bool IsDebugEnabled = false;

        private FightableCharacter parent;

        protected void Start()
        {
            parent = gameObject.transform.parent.gameObject.GetComponent<FightableCharacter>();
        }

        protected void OnTriggerEnter(Collider p_col)
        {
            if (IsDebugEnabled) { DebugLogger.LogMessage(gameObject.name + " detected a collision with " + p_col.name); }
            if (p_col.gameObject.tag == "PlayerWorldAvatar")
            {
                parent.OnEnterCombatSphere();
            }
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public abstract class Enemy : FightableCharacter
    {
        
        protected CharacterController characterController;

        public int EncounterEnemiesCount;
        public EncounterProbability[] EncounterTable;

        

        public abstract void ComputeAI();

        [Serializable]
        public struct EncounterProbability
        {
            public EPrefabID EnemyId;
            public float Probability;
            public int Limit;
        }

        protected new void Start()
        {
            base.Start();
            animator = gameObject.GetComponent<Animator>();
            characterController = gameObject.GetComponent<CharacterController>();
        }

        protected new void Update()
        {
            base.Update();
        }

        public List<EPrefabID> GetEncounterEnemies()
        {
            List<EPrefabID> encounterList = new List<EPrefabID>();
            float rand;
            EPrefabID enemyIdBuffer = EPrefabID.Null;
            int enemyLimitBuffer = 0;

            while (encounterList.Count < EncounterEnemiesCount)
            {
                rand = Random.Range(0.0f, 1.0f);

                for (int i = 0; i < EncounterTable.Length; i++)
                {
                    if (i == 0)
                    {
                        if (rand >= 0 && rand < EncounterTable[i].Probability)
                        {
                            enemyIdBuffer = EncounterTable[i].EnemyId;
                            enemyLimitBuffer = EncounterTable[i].Limit;
                        }
                    }
                    else
                    {
                        if (rand >= EncounterTable[i - 1].Probability 
                            && rand < EncounterTable[i - 1].Probability + EncounterTable[i].Probability)
                        {
                            enemyIdBuffer = EncounterTable[i].EnemyId;
                            enemyLimitBuffer = EncounterTable[i].Limit;
                        }
                    }

                    int enemyLimitCount = 0;
                    for (int j = 0; j < encounterList.Count; j++)
                    {
                        if (enemyIdBuffer == encounterList[j])
                        {
                            enemyLimitCount++;
                        }
                    }
                    if (enemyLimitCount < enemyLimitBuffer || enemyIdBuffer == 0)
                    {
                        encounterList.Add(enemyIdBuffer);
                    }
                }
            }

            return encounterList;
        }

        public override void OnEnterCombatSphere()
        {
            if (!GameState.Player.IsInCombat)
                CombatManager.FireStartCombatEvent(GetEncounterEnemies(), GameState.GetPlayerPartyPrefabs());
        }
    }

    /************************************************
     *                  Interfaces                  *
     ************************************************/

    public interface IBoardCharacter
    {
        void MoveTo(Vector3 p_point);
    }

    public interface IInteractiveCharacter
    {
        void Talk();
    }
}
