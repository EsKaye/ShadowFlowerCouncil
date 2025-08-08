using UnityEngine;
using System;

/// <summary>
/// Simple in-scene event bus used for cross-guardian whispers.
/// This keeps guardians decoupled while allowing message passing.
/// </summary>
public class LilybearOpsBus : MonoBehaviour
{
    public static LilybearOpsBus I;

    public delegate void Whisper(string from, string to, string message);
    public event Whisper OnWhisper;

    private void Awake()
    {
        I = this; // Singleton pattern for easy access
    }

    public void Say(string from, string to, string message)
    {
        OnWhisper?.Invoke(from, to, message);
        Debug.Log($"[LilybearBus] {from} -> {to}: {message}");
    }
}
