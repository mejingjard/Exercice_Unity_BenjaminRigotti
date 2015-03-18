using UnityEngine;
using System.Collections;

namespace Controller
{
    public class ThirdPersonCamera : MonoBehaviour
    {
        public GameObject Target;

        public Vector3 InitialCameraLocalPosition = new Vector3(0, 8, 15);
        public Vector3 LookAtOffset = new Vector3(0, 5, 0);

        public bool SmoothMovement = true;

        private const float RotationDamping = 15.0f;
        private const float MovementDamping = 6.0f;

        private GUITexture guiTextureInstance;
        private const float FadeSpeed = 1.0f; // Speed that the screen fades to and from black.

        protected void Start()
        {
            guiTextureInstance = GetComponent<GUITexture>();

            gameObject.transform.position = Target.transform.position + InitialCameraLocalPosition;
            Transform target = Target.transform;
            target.position += LookAtOffset;

            transform.LookAt(Target.transform);
        }

        protected void LateUpdate()
        {
            ExecuteCamera(Target.transform);
        }

        private void ExecuteCamera(Transform p_target)
        {
            if (SmoothMovement)
            {
                Quaternion rotation = Quaternion.LookRotation(p_target.position + LookAtOffset - transform.position);
                transform.rotation = Quaternion.Slerp(transform.rotation, rotation, Time.deltaTime * RotationDamping);

                Vector3 targetBackVector = Target.transform.TransformDirection(Vector3.back);
                Vector3 destination = new Vector3(Target.transform.position.x + targetBackVector.x * InitialCameraLocalPosition.z, Target.transform.position.y + InitialCameraLocalPosition.y, Target.transform.position.z + targetBackVector.z * InitialCameraLocalPosition.z);
                Vector3 position = Vector3.Lerp(transform.position, destination, Time.deltaTime * MovementDamping);

                transform.position = position;
            }
            else
            {
                Transform target = p_target;
                p_target.position += LookAtOffset;
                transform.LookAt(target);
            }
        }
    }
}