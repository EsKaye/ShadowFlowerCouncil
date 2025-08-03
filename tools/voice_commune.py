"""Voice communion recording and encryption utilities.

Provides a minimal CLI for capturing audio, encrypting it, and storing the
symmetric key. Error handling and logging were added for safer ritual use.
"""
from __future__ import annotations

import argparse
import logging
from pathlib import Path
from typing import Optional

try:
    import sounddevice as sd
    from scipy.io.wavfile import write as wav_write
    from cryptography.fernet import Fernet
except ImportError as exc:  # pragma: no cover - environment-specific
    raise SystemExit(
        "Missing dependencies: sounddevice, scipy, cryptography. Install with pip"
    ) from exc

logging.basicConfig(level=logging.INFO, format="[%(asctime)s] %(levelname)s: %(message)s")


def record_audio(duration: int, sample_rate: int = 44100):
    """Record audio for a given duration (seconds)."""
    logging.info("Recording %ss of audio", duration)
    try:
        data = sd.rec(int(duration * sample_rate), samplerate=sample_rate, channels=1)
        sd.wait()
    except Exception as exc:  # pragma: no cover - audio hardware dependent
        logging.error("Audio recording failed: %s", exc)
        raise
    return data


def encrypt_file(input_path: Path, key: bytes) -> Path:
    """Encrypt a file using Fernet symmetric encryption."""
    cipher = Fernet(key)
    encrypted_path = input_path.with_suffix(input_path.suffix + ".enc")
    with input_path.open("rb") as f_in, encrypted_path.open("wb") as f_out:
        f_out.write(cipher.encrypt(f_in.read()))
    return encrypted_path


def ensure_key(keyfile: Path) -> bytes:
    """Load an existing key or create a new one."""
    if keyfile.exists():
        return keyfile.read_bytes()
    key = Fernet.generate_key()
    keyfile.write_bytes(key)
    return key


def main(argv: Optional[list[str]] = None) -> int:
    parser = argparse.ArgumentParser(description="Async voice communion")
    parser.add_argument("-d", "--duration", type=int, default=5, help="Recording duration in seconds")
    parser.add_argument("-o", "--output", type=Path, default=Path("voice_log.wav"), help="Output WAV file")
    parser.add_argument("-k", "--keyfile", type=Path, default=Path("voice_key.key"), help="Encryption key file")
    args = parser.parse_args(argv)

    key = ensure_key(args.keyfile)
    audio = record_audio(args.duration)
    wav_write(args.output, 44100, audio)
    enc_path = encrypt_file(args.output, key)
    logging.info("Encrypted voice log written to %s", enc_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
