using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Utilities;
using Random = UnityEngine.Random;

namespace Character
{
    /// <summary>
    /// Bee AI implementation
    /// </summary>
    public class Bee : Enemy
    {
        protected new void Start()
        {
            base.Start();
        }

        public override void ComputeAI()
        {
            // For testing purpose
            switch (Random.Range(0, 4))
            {
                case 0:
                    //Attack();
                    break;

                case 1:
                    Defend();
                    break;

                case 2:
                    CounterAttack();
                    break;

                case 3:
                    MagicAttack();
                    break;

                case 4:

                    break;
            }
        }

        public override void Move(Vector3 p_motion)
        {
            characterController.Move(p_motion);
        }

        public override void OnEnterCombatSphere()
        {
            CombatManager.FireStartCombatEvent(GetEncounterEnemies(), GameState.GetPlayerPartyPrefabs());
        }

        public override void Attack(Character p_target)
        {
            if (IsDebugEnabled) DebugLogger.LogMessage("Bee is attacking");

            StartCoroutine(Attack_Coroutine(p_target));
        }

        private IEnumerator Attack_Coroutine(Character p_target)
        {
            Vector3 previousPos = gameObject.transform.position;
            Debug.Log(previousPos);
            Quaternion previousRot = gameObject.transform.rotation;

            MoveTo(p_target.transform.position - p_target.transform.TransformDirection(Vector3.forward) * -5);
            while (!(gameObject.transform.position.x.NearlyEqual(targetPoint.x, 0.1f)
                && gameObject.transform.position.z.NearlyEqual(targetPoint.z, 0.1f)))
            {
                yield return 0;
            }

            animator.SetTrigger("Attack");
            yield return new WaitForSeconds(0.5f);
            p_target.Hit(0); // todo: compute damage based on equipment + stats once inventory system is implemented
            yield return new WaitForSeconds(0.5f);

            gameObject.transform.LookAt(previousPos);
            MoveTo(previousPos);
            while (!(gameObject.transform.position.x.NearlyEqual(targetPoint.x, 0.1f)
                && gameObject.transform.position.z.NearlyEqual(targetPoint.z, 0.1f)))
            {
                yield return 0;
            }
            gameObject.transform.rotation = previousRot;
            gameObject.transform.position = previousPos;
        }

        public override void Defend()
        {
            if (IsDebugEnabled) DebugLogger.LogMessage("Bee is defending");

            throw new NotImplementedException();
        }

        public override void CounterAttack()
        {
            if (IsDebugEnabled) DebugLogger.LogMessage("Bee is counter attacking");

            throw new NotImplementedException();
        }

        public override void MagicAttack()
        {
            if (IsDebugEnabled) DebugLogger.LogMessage("Bee is using a magic attack");

            throw new NotImplementedException();
        }

        public override void Hit(int p_damages)
        {
            animator.SetTrigger("Hit");
        }

        public override void MoveTo(Vector3 p_point)
        {
            targetPoint = p_point;
        }
    }
}