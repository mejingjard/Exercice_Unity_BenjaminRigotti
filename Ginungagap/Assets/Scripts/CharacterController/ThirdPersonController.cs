using System;
using UnityEngine;
using System.Collections;

namespace Controller
{
    [RequireComponent(typeof(Animator))]
    [RequireComponent(typeof(CharacterController))]
    public class ThirdPersonController : MonoBehaviour
    {
        public const float WalkSpeed = 8.0f;
        public const float BackwardSpeed = 5.0f;
        public const float SprintSpeed = 20.0f;

        public const float SpeedSmoothing = 5.0f;
        public const float RotationSpeedWalk = 90.0f;
        public const float RotationSpeedSprint = 180.0f;

        private Vector3 moveDirection = Vector3.zero;
        private Vector3 moveVector = Vector3.zero;
        private Vector3 lastMoveVector = Vector3.zero;
        private float verticalSpeed = 0.0f;
        private float moveSpeed = 0.0f;
        private float lastMoveSpeed = 0.0f;

        private bool IsSprinting
        {
            get { return Input.GetKey(SprintKey); }
        }

        #region INPUT KEY BINDING

        public KeyCode ForwardKey = KeyCode.Z;
        public KeyCode BackwardKey = KeyCode.S;
        public KeyCode RotateLeftKey = KeyCode.Q;
        public KeyCode RotateRightKey = KeyCode.D;

        public KeyCode SprintKey = KeyCode.LeftShift;
        public KeyCode JumpKey = KeyCode.Space;

        #endregion

        private CharacterController characterController;
        private Animator animatorInstance;

        protected void Start()
        {
            characterController = gameObject.GetComponent<CharacterController>();
            animatorInstance = gameObject.GetComponent<Animator>();

            moveDirection = transform.TransformDirection(Vector3.forward);
            animatorInstance.SetBool("InBattle", false);
        }


        protected void Update()
        {
            moveDirection = transform.TransformDirection(Vector3.forward);

            lastMoveSpeed = moveSpeed;
            float rotationSpeed = RotationSpeedWalk;

            // SPRINT
            if (Input.GetKey(ForwardKey) && IsSprinting)
            {
                moveSpeed = Mathf.Lerp(lastMoveSpeed, SprintSpeed, Time.deltaTime * SpeedSmoothing);
                rotationSpeed = RotationSpeedSprint;
            }
            else if (Input.GetKey(ForwardKey) && !Input.GetKey(BackwardKey))
            {
                moveSpeed = Mathf.Lerp(lastMoveSpeed, WalkSpeed, Time.deltaTime * SpeedSmoothing);
            }
            else if (Input.GetKey(BackwardKey) && !Input.GetKey(ForwardKey))
            {
                moveSpeed = Mathf.Lerp(lastMoveSpeed, BackwardSpeed, Time.deltaTime * SpeedSmoothing);
            }
            else
            {
                moveSpeed = Mathf.Lerp(lastMoveSpeed, 0.0f, Time.deltaTime * SpeedSmoothing);
            }

            animatorInstance.SetFloat("Speed", moveSpeed / SprintSpeed);

            // FORWARD
            if (Input.GetKey(ForwardKey) && !Input.GetKey(BackwardKey))
            {
                lastMoveVector = moveVector;
                moveVector = moveDirection * moveSpeed + new Vector3(0, verticalSpeed, 0);
                moveVector *= Time.deltaTime;
                moveVector = Vector3.Lerp(lastMoveVector, moveVector, Time.deltaTime * SpeedSmoothing);
            }
            // BACKWARD
            else if (Input.GetKey(BackwardKey) && !Input.GetKey(ForwardKey))
            {
                lastMoveVector = moveVector;
                moveVector = -moveDirection * moveSpeed + new Vector3(0, verticalSpeed, 0);
                moveVector *= Time.deltaTime;
                moveVector = Vector3.Lerp(lastMoveVector, moveVector, Time.deltaTime * SpeedSmoothing);
            }
            else
            {
                lastMoveVector = moveVector;
                moveVector = Vector3.Lerp(lastMoveVector, Vector3.zero, Time.deltaTime * SpeedSmoothing);
            }

            // ROTATE LEFT
            if (Input.GetKey(RotateLeftKey) && !Input.GetKey(RotateRightKey))
            {
                Quaternion rotation = Quaternion.Euler(gameObject.transform.rotation.eulerAngles - new Vector3(0, rotationSpeed * Time.deltaTime, 0));
                gameObject.transform.rotation = rotation;
            }

            // ROTATE RIGHT
            if (Input.GetKey(RotateRightKey) && !Input.GetKey(RotateLeftKey))
            {
                Quaternion rotation = Quaternion.Euler(gameObject.transform.rotation.eulerAngles + new Vector3(0, rotationSpeed * Time.deltaTime, 0));
                gameObject.transform.rotation = rotation;
            }

            // Gravity 

            moveVector.y += Physics.gravity.y * Time.deltaTime;

            // Apply movement vector
            if (moveVector != Vector3.zero)
            {
                characterController.Move(moveVector);
            }
        }
    }

}

