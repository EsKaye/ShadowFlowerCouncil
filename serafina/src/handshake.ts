/*
 * Inter-repo handshake protocol for ShadowFlower network.
 * This module allows Serafina to announce its presence to
 * sibling services, creating a mesh of cooperating agents.
 *
 * Each peer exposes a `/handshake` endpoint. Serafina posts
 * a JSON payload containing its node identifier and a
 * timestamp, enabling peers to register or respond.
 */

import fetch from 'node-fetch';

interface HandshakePayload {
  node: string; // current service identifier
  timestamp: number; // unix epoch ms for traceability
}

/**
 * Perform handshakes with all configured peers.
 * Peers are defined as a comma-separated list of base URLs
 * in the `HANDSHAKE_PEERS` environment variable.
 */
export async function performHandshakes(): Promise<void> {
  const peers = (process.env.HANDSHAKE_PEERS || '')
    .split(',')
    .map(s => s.trim())
    .filter(Boolean);

  if (!peers.length) {
    console.log('[Handshake] No peers configured.');
    return;
  }

  const payload: HandshakePayload = {
    node: process.env.NODE_ID || 'serafina',
    timestamp: Date.now(),
  };

  await Promise.all(
    peers.map(async url => {
      try {
        const res = await fetch(`${url.replace(/\/$/, '')}/handshake`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(payload),
        });
        console.log(`[Handshake] ${url} -> ${res.status}`);
      } catch (err) {
        console.error(`[Handshake] Failed to contact ${url}`, err);
      }
    })
  );
}

/**
 * Future Improvements:
 * - Verify peer identity with shared secrets or signatures.
 * - Maintain a peer registry with heartbeat checks.
 * - Promote to WebSocket-based mesh for real-time sync.
 */
