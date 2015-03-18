using System;
using UnityEngine;

public class DebugLogger
{
    public static void LogMessage(string p_message)
    {
        Debug.Log("[" + DateTime.Now.ToString("hh:mm:ss") + "] - " + p_message);
    }

    public static void LogWarning(string p_warning)
    {
        Debug.LogWarning("[" + DateTime.Now.ToString("hh:mm:ss") + "] - " + p_warning);
    }

    public static void LogError(string p_error)
    {
        Debug.LogError("[" + DateTime.Now.ToString("hh:mm:ss") + "] - " + p_error);
    }
}