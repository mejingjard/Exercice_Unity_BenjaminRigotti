using System;
using UnityEngine;
using System.Collections;
using Controller;
using System.Collections.Generic;
using Utilities;
using EPrefabID = PrefabDatabase.EPrefabID;

namespace Character
{
    [RequireComponent(typeof(Animator))]
    [RequireComponent(typeof(CharacterController))]
    public abstract class PlayableCharacter : Character 
    {
        public EClass Class;
        public int Experience;

        public Animator animator;
        protected CharacterController characterController;

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

        protected void Awake()
        {
            
        }

        protected void Start()
        {
            animator = gameObject.GetComponent<Animator>();
            characterController = gameObject.GetComponent<CharacterController>();

            targetPoint = transform.position;
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

        public void MoveTo(Vector3 position)
        {
            targetPoint = position;
        }
    }

    public enum PlayableCharactersID
    {
        Null = -1,
        Melissandre = EPrefabID.Melissandre
    };
}
    