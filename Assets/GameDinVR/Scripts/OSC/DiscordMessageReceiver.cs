using UnityEngine;

/// <summary>
/// Receives JSON payloads from the external Discord bridge and
/// forwards them into the LilybearOpsBus so guardians can react.
/// The bridge can invoke Receive via Unity's SendMessage or an OSC hook.
/// </summary>
public class DiscordMessageReceiver : MonoBehaviour
{
    [System.Serializable]
    private class Payload
    {
        public string to;
        public string message;
    }

    public void Receive(string json)
    {
        var payload = JsonUtility.FromJson<Payload>(json);
        if (payload == null) return;
        LilybearOpsBus.I?.Say("Discord", payload.to, payload.message);
    }
}
