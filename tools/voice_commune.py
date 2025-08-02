"""Voice communion recording and encryption."""
import argparse
import os
import datetime
from pathlib import Path

try:
    import sounddevice as sd
    from scipy.io.wavfile import write as wav_write
    from cryptography.fernet import Fernet
except ImportError as e:
    print("Missing dependencies:", e)
    print("Install with: pip install sounddevice scipy cryptography")
    raise


def record_audio(duration: int, sample_rate: int = 44100):
    """Record audio for a given duration (seconds)."""
    print(f"Recording {duration}s of audio...")
    data = sd.rec(int(duration * sample_rate), samplerate=sample_rate, channels=1)
    sd.wait()
    return data


def encrypt_file(input_path: Path, key: bytes) -> Path:
    """Encrypt a file using Fernet symmetric encryption."""
    cipher = Fernet(key)
    encrypted_path = input_path.with_suffix(input_path.suffix + '.enc')
    with open(input_path, 'rb') as f_in, open(encrypted_path, 'wb') as f_out:
        f_out.write(cipher.encrypt(f_in.read()))
    return encrypted_path


def main():
    parser = argparse.ArgumentParser(description="Async voice communion")
    parser.add_argument('-d', '--duration', type=int, default=5, help='Duration of recording in seconds')
    parser.add_argument('-o', '--output', type=Path, default=Path('voice_log.wav'), help='Output WAV file')
    parser.add_argument('-k', '--keyfile', type=Path, default=Path('voice_key.key'), help='Encryption key file')
    args = parser.parse_args()

    if not args.keyfile.exists():
        key = Fernet.generate_key()
        args.keyfile.write_bytes(key)
    else:
        key = args.keyfile.read_bytes()

    audio = record_audio(args.duration)
    wav_write(args.output, 44100, audio)
    enc_path = encrypt_file(args.output, key)
    print(f"Encrypted voice log written to {enc_path}")


if __name__ == '__main__':
    main()
