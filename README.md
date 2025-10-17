<div align="center">
  <a href="https://ollama.com" />
    <img alt="ollama" height="200px" src="https://github.com/ollama/ollama/assets/3325447/0d0b44e2-8f4a-4e99-9b52-a5c1c741c8f7">
  </a>
</div>

# Ollama in Termux

## Installation Options

### Option 1: Install from Termux Repository (Recommended)
Ollama is available in the Termux package repository:

```bash
apt install ollama -y
```

### Option 2: Install Latest Version from Source
This script installs the latest version directly from GitHub source:

```bash
curl -sL https://github.com/Anon4You/ollama-in-termux/raw/main/ollama.sh | bash
```

## Usage
After installation:

```bash
ollama serve          # Start the server
ollama run <model>    # Run a model (e.g., ollama run llama3)
ollama list           # List installed models
ollama pull <model>   # Download a model
```

## Features of Source Installation
- Always installs the latest version from GitHub
- Compiles from source with Go
- Custom build flags for release mode
- Automatic dependency installation

## Notes
- The repository version is stable and recommended for most users
- Source installation may require more time and resources
- Ensure you have sufficient storage for models

## Author
Code by [Alienkrishn](https://github.com/Anon4You)

