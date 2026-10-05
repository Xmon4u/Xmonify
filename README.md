# Xmonify CLI

<p align="center">
  <b>A powerful command-line tool to customize the official Spotify client.</b>
  <br>
  <i>Customized and maintained by <b>XMON4U</b></i>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Developer-XMON4U-blue.svg?style=flat-square" alt="Developer XMON4U">
  <img src="https://img.shields.io/badge/Version-2.45.3-green.svg?style=flat-square" alt="Version 2.45.3">
  <img src="https://img.shields.io/badge/License-GNU%20LGPL%20v2.1-orange.svg?style=flat-square" alt="License LGPL 2.1">
  <img src="https://img.shields.io/badge/Go-1.26+-00ADD8.svg?style=flat-square&logo=go" alt="Go Version">
</p>

---

## 🚀 Overview

**Xmonify CLI** gives you complete control over your Spotify desktop experience across Windows, macOS, and Linux. Easily personalize your interface, extend features, and apply custom themes.

### ✨ Features

- 🎨 **Theme & Color Customization:** Switch between curated color palettes or craft your own UI appearance.
- 💉 **CSS Injection:** Apply custom CSS rules directly to the Spotify client interface.
- 🧩 **Extension Support:** Inject custom JavaScript extensions to enhance client functionality (e.g., ad skip, shortcut navigation, popup lyrics, shuffle+).
- 📱 **Custom Apps:** Embed dedicated web apps directly into Spotify.
- ⚡ **Lightweight & Fast:** Built in Go with near-instant execution and hot-refresh support.

---

## 🛠️ Getting Started

### Requirements
- [Go](https://go.dev/dl/) (1.24+ recommended)
- [Node.js](https://nodejs.org/) & [pnpm](https://pnpm.io/)
- Spotify Desktop Client

### Building from Source

1. Clone or download the repository:
   ```bash
   git clone https://github.com/XMON4U/xmonify.git
   cd xmonify
   ```

2. Install dependencies and build the wrapper helper:
   ```bash
   pnpm install
   pnpm build:wrapper
   ```

3. Compile the executable:
   * **Windows:**
     ```powershell
     go build -o xmonify.exe
     ```
   * **Linux & macOS:**
     ```bash
     go build -o xmonify
     ```

---

## 📖 Usage & Commands

```bash
# Basic setup and apply customizations
xmonify backup apply

# Refresh applied theme and extensions
xmonify refresh

# Enter live watch mode during theme development
xmonify watch -s

# Restore Spotify back to original state
xmonify restore
```

---

## 👤 Developer & Maintainer

* **Developer:** **XMON4U**
* **GitHub:** [https://github.com/XMON4U](https://github.com/XMON4U)

---

## 📜 Attribution & License

This project is a customized distribution based on the open-source **Spicetify CLI** project originally created by **khanhas** and maintained by the **Spicetify Contributors**.

Licensed under the **GNU Lesser General Public License v2.1 (LGPL-2.1)**. See [LICENSE](LICENSE) for full details.

