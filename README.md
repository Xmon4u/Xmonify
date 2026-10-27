# Xmonify CLI

[![Go Version](https://img.shields.io/badge/Go-1.24%2B-blue.svg)](https://go.dev/)
[![License: LGPL 2.1](https://img.shields.io/badge/License-LGPL%202.1-orange.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)](https://github.com/Xmon4u/Xmonify)

A command-line tool to customize and extend the official Spotify desktop client on Windows, macOS, and Linux.

## Features

- **Theme & Color Styling**: Apply custom themes and switch between color palettes without modifying original Spotify binaries permanently.
- **Custom CSS Injection**: Inject custom CSS rules directly into the Spotify client UI.
- **JavaScript Extensions**: Load custom client extensions (keyboard shortcuts, popup lyrics, enhanced shuffle, queue improvements).
- **Custom Apps**: Embed dedicated mini web applications directly inside Spotify navigation views.
- **Quick Backup & Restore**: Safe backup mechanism allowing one-command restoration to Spotify's stock state.

## Requirements

- Spotify Desktop Client (installed via official installer)
- [Go](https://go.dev/dl/) 1.24 or newer
- [Node.js](https://nodejs.org/) & [pnpm](https://pnpm.io/) (for building the JS wrapper)

## Building from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/Xmon4u/Xmonify.git
   cd Xmonify
   ```

2. Install dependencies and compile the wrapper:
   ```bash
   pnpm install
   pnpm build:wrapper
   ```

3. Compile the Go binary:
   - **Windows**:
     ```powershell
     go build -o xmonify.exe
     ```
   - **Linux & macOS**:
     ```bash
     go build -o xmonify
     ```

## Common Commands

```bash
# Back up original Spotify files and apply active configuration
xmonify backup apply

# Re-apply theme or extension modifications after editing configs
xmonify refresh

# Start live watch mode during theme/CSS development
xmonify watch -s

# Restore Spotify back to its stock state
xmonify restore
```

## Attribution & License

Xmonify is a customized distribution based on the open-source **Spicetify CLI** project originally created by **khanhas** and maintained by the **Spicetify Community**.

This project is licensed under the **GNU Lesser General Public License v2.1 (LGPL-2.1)**. See [LICENSE](LICENSE) for details.
