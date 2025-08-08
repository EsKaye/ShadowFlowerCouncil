import fetch from 'node-fetch';

const UNITY_URL = process.env.UNITY_BRIDGE_URL;

/**
 * Relay a message to the Unity layer.
 * The Unity bridge is expected to expose an HTTP endpoint
 * that forwards this payload into the in-world event bus.
 */
export async function relayToUnity(to: string, message: string): Promise<void> {
  // Guard: if no bridge configured, log and bail so the bot remains healthy
  if (!UNITY_URL) {
    console.warn('UNITY_BRIDGE_URL not set; skipping Unity relay');
    return;
  }
  try {
    await fetch(UNITY_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ to, message })
    });
  } catch (err) {
    // Verbose log to aid diagnostics in dev environments
    console.error('Failed to relay message to Unity', err);
  }
}
