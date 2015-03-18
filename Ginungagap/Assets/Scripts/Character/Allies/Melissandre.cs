using Character;
using UnityEngine;
using System.Collections;
using Utilities;

namespace Character
{
    public class Melissandre : PlayableCharacter
    {
        protected new void Awake()
        {
            base.Awake();
        }

        protected new void Start()
        {
            base.Start();
        }

        protected new void Update()
        {
            base.Update();
        }

        public override void Attack(Character p_target)
        {
            StartCoroutine(Attack_Coroutine(p_target));
        }

        public override void Move(Vector3 p_motion)
        {
            characterController.Move(p_motion);
        }

        private IEnumerator Attack_Coroutine(Character p_enemy)
        {
            Vector3 previousPos = gameObject.transform.position;
            Quaternion previousRot = gameObject.transform.rotation;

            MoveTo(p_enemy.transform.position - p_enemy.transform.TransformDirection(Vector3.forward) * -5);
            while (!(gameObject.transform.position.x.NearlyEqual(targetPoint.x, 0.1f)
                && gameObject.transform.position.z.NearlyEqual(targetPoint.z, 0.1f)))
            {
                yield return 0;
            }

            animator.SetTrigger("Attack");
            yield return new WaitForSeconds(0.5f);
            p_enemy.Hit(0); // todo: compute damage based on equipment + stats once inventory system is implemented
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
            throw new System.NotImplementedException();
        }

        public override void CounterAttack()
        {
            throw new System.NotImplementedException();
        }

        public override void MagicAttack()
        {
            throw new System.NotImplementedException();
        }

        public override void Hit(int p_damages)
        {
            animator.SetTrigger("Hit");
        }
    }
}
