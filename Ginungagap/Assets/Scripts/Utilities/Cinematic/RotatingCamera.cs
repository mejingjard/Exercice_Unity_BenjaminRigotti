using System;
using UnityEngine;
using System.Collections;

namespace Utilities.Cinematic
{
    [RequireComponent(typeof(Camera))]
    public class RotatingCamera : MonoBehaviour
    {
        public GameObject Target;
        public Vector3 TargetOffset;
        public float DistanceFromTarget;
        public Vector3 RotationSpeed;

        public bool AlwaysLookAtTarget;
        public Vector3 LookOffset;

        private Quaternion rotation = Quaternion.identity;

        // Update is called once per frame
        void Update()
        {
            double x, y, z;

            x = Target.transform.position.x + DistanceFromTarget * Math.Cos(rotation.x) * Math.Sin(rotation.y);
            y = Target.transform.position.y + DistanceFromTarget * Math.Sin(rotation.x) * Math.Sin(rotation.y);
            z = Target.transform.position.z + DistanceFromTarget * Math.Cos(rotation.y);

            rotation.x += Time.deltaTime * RotationSpeed.x;
            rotation.y += Time.deltaTime * RotationSpeed.y;
            rotation.z += Time.deltaTime * RotationSpeed.z;

            gameObject.transform.position = new Vector3((float)x, (float)y, (float)z) + TargetOffset;

            if (AlwaysLookAtTarget)
            {
                Vector3 buffer = Target.transform.position + LookOffset;
                transform.LookAt(buffer);
            }
        }
    }
}
