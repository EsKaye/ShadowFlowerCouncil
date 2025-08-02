# Voice Communion

`tools/voice_commune.py` records audio and encrypts it for asynchronous sharing.

Install dependencies:

```bash
pip install sounddevice scipy cryptography
```

Run the recorder:

```bash
python tools/voice_commune.py --duration 10 --output session.wav
```
