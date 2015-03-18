using System;
using System.Collections;
using UnityEngine;

namespace Utilities
{
    static class FloatingPointComparison
    {
        public static bool NearlyEqual(this double a, double b, double epsilon)
        {
            if (Math.Abs(a - b) < epsilon)
            {
                return true;
            }
            return false;
        }

        public static bool NearlyEqual(this float a, float b, float epsilon)
        {
            if (Math.Abs(a - b) < epsilon)
            {
                return true;
            }
            return false;
        }

        public static bool NearlyEqual(this Vector3 a, Vector3 b, float epsilon)
        {
            return a.x.NearlyEqual(b.x, epsilon)
                   && a.y.NearlyEqual(b.y, epsilon)
                   && a.z.NearlyEqual(b.z, epsilon);
        }
    }
}
