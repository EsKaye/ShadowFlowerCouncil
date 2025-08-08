using UnityEngine;

/// <summary>
/// Lilybear: voice & operations controller that can broadcast messages.
/// </summary>
public class LilybearController : GuardianBase
{
    [TextArea]
    public string LastMessage;

    private void Start()
    {
        GuardianName = "Lilybear";
        Role = "Voice & Operations";
    }

    public override void OnMessage(string from, string message)
    {
        LastMessage = $"{from}: {message}";
        // Example: if someone whispers '/route', broadcast the payload to all
        if (message.StartsWith("/route "))
        {
            var payload = message.Substring(7);
            Whisper("*", payload);
        }
    }

    [ContextMenu("Test Whisper")]
    private void TestWhisper()
    {
        Whisper("*", "The council is assembled.");
    }
}
