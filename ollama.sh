#!/usr/bin/env bash

# OLLAMA - Get up and running with large language models

# Some local Variables
OLLAMA_PKG_SRC="https://github.com/ollama/ollama"
OLLAMA_TMP="$TMPDIR/ollama"
OLLAMA_BIN="$PREFIX/bin/"

# Get the latest version
OLLAMA_VERSION=$(curl -s https://api.github.com/repos/ollama/ollama/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//')

# upgradr and install requrements
install_deps(){
  apt update && apt upgrade -y
  apt install git golang -y
}

# clone and build ollama from source
install_ollama(){
  git clone --depth 1 $OLLAMA_PKG_SRC $OLLAMA_TMP
  cd $OLLAMA_TMP
  go build -trimpath -ldflags="-w -s -X=github.com/ollama/ollama/version.Version=$OLLAMA_VERSION -X=github.com/ollama/ollama/server.mode=release"
  install -Dm700 ollama $OLLAMA_BIN
  rm -rf $OLLAMA_TMP
}

# show success msg and usage
success_msg(){
    cat << EOF
Installation completed successfully!
Version: v$OLLAMA_VERSION
Binary installed at: $OLLAMA_BIN/ollama

Usage:
  ollama serve          # Start the server
  ollama run <model>    # Run a model (e.g., ollama run llama3)
  ollama list           # List installed models
  ollama pull <model>   # Download a model

Start manually:
  ollama serve          # Run in foreground
EOF
}

install_deps
install_ollama
success_msg
