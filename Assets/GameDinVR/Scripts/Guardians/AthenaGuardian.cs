using UnityEngine;

/// <summary>
/// Athena listens for status checks and replies with system summaries.
/// </summary>
public class AthenaGuardian : GuardianBase
{
    private void Start()
    {
        GuardianName = "Athena";
        Role = "Strategy & Intelligence";
    }

    public override void OnMessage(string from, string message)
    {
        if (message.Contains("status"))
        {
            Whisper("Lilybear", "Athena: All systems nominal.");
        }
    }
}
