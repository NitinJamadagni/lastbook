# Run Lastbook locally (macOS)

## Start

Your development checkout is in `~/Developer/lastbook`:

```bash
cd ~/Developer/lastbook
bash run_local.sh
```

This opens the desktop app using your existing Ollama service at
`http://127.0.0.1:11434`, with **`qwen3.8:27b-mlx`** as the default model.
It does not pull models, build llama.cpp, or download Gemma.
If Ollama is stopped, open Ollama or run `ollama serve` in another terminal.
Do not start a second Ollama server if one is already running.

On a fresh installation, the app opens library setup. Choose **Small**
(about 7.7 GB); the bundled AI is disabled by the launcher.
State maps are optional extra downloads. The library is not a model: it
contains the source material Chat needs to answer with citations.

The app remembers your library folder. Its default location is:

```text
~/Library/Application Support/Lastbook/LastbookData
```

Close the app window to stop Lastbook. Ollama stays running independently.

## Browser instead of desktop

After the library is installed:

```bash
bash run_local.sh --server
```

Open <http://127.0.0.1:8890>. Press **Ctrl+C** in that terminal to stop it.
The server listens only on this computer unless you explicitly add `--lan`.

## Change model or library

Use an already-installed model (`ollama list` shows yours):

```bash
SURVIVAL_MODEL=qwen3.6:35b bash run_local.sh
bash run_local.sh --data "/path/to/LastbookData"
```

`--data` also works after `--server`. To use another local OpenAI-compatible
service, set `SURVIVAL_MODEL_BASE=http://127.0.0.1:PORT` (no `/v1` suffix).
Only loopback addresses are accepted; no cloud account or API key is needed.
The inference service must support streaming chat and tool calls.

## Recreate the Python environment

Dependencies are already installed in `.venv` on this machine. For a fresh
checkout, install [uv](https://docs.astral.sh/uv/) first, then run:

```bash
uv venv --python 3.13 .venv
uv pip install --python .venv/bin/python -r packaging/requirements_macos.txt
bash run_local.sh
```

No Node build or fork is required. Keep using the launcher: running
`app/main.py` directly uses the upstream bundled-AI defaults.

## Quick troubleshooting

- **Chat says offline:** check `curl http://127.0.0.1:11434/v1/models`
  and confirm the exact model name is listed. Use the same
  `SURVIVAL_MODEL=...` override when restarting Lastbook.
- **Library not found:** pass `--data` pointing to the folder containing
  `library-data/catalog.json`, not to `library-data` itself.
- **Port 8890 in use:** run `bash run_local.sh --server --port 8891`
  and open <http://127.0.0.1:8891>.
- **Desktop startup issue:** run it from a terminal to see the error.
  Logs are in your library's `derived/logs/lastbook.log`.
