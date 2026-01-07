# 🚚 Scoop-Apeiraco

> _A bucket of unconventional software that official repos won't carry._

Curating practical tools that mainstream buckets overlook — developer utilities, geek essentials, ACGN apps, and more.

[![Excavator](https://github.com/apeiraco/scoop-bucket/actions/workflows/excavator.yml/badge.svg)](https://github.com/apeiraco/scoop-bucket/actions/workflows/excavator.yml)
[![License](https://img.shields.io/badge/license-Unlicense-blue)](LICENSE)

**[🇨🇳 简体中文](README_CN.md)**

---

## 📦 App Catalog

### 💻 Developer Tools

| App                                                       | Description                                                               |
| --------------------------------------------------------- | ------------------------------------------------------------------------- |
| **[fresh](https://github.com/sinelaw/fresh)**             | A terminal text editor you can just use                                   |
| **[ut](https://github.com/ksdme/ut)**                     | A fast, lightweight CLI utility toolkit                                   |
| **[seaweedfs](https://github.com/seaweedfs/seaweedfs)**   | Fast distributed storage system for blobs, objects & files                |
| **[minio (archive)](https://github.com/minio/minio)**     | High-performance object storage server (archived build with legacy WebUI) |
| **[minio-client (archive)](https://github.com/minio/mc)** | Command-line client for MinIO object storage (archived)                   |

### 🔧 Geek Tools

| App                                                                           | Description                                         |
| ----------------------------------------------------------------------------- | --------------------------------------------------- |
| **[ContextMenuManager](https://bluepointlilac.github.io/ContextMenuManager)** | Manage Windows right-click context menus            |
| **[Dism++](https://github.com/Chuyu-Team/Dism-Multi-language)**               | Powerful Windows system optimization & cleanup tool |
| **[UEFIExtract](https://github.com/LongSoft/UEFITool)**                       | UEFI firmware image extractor (Command Line)        |
| **[UEFIFind](https://github.com/LongSoft/UEFITool)**                          | UEFI firmware image finder (Command Line)           |
| **[UEFITool](https://github.com/LongSoft/UEFITool)**                          | UEFI firmware image viewer and editor (New Engine)  |

### 🎌 ACGN Tools

| App                                                              | Description                                                          |
| ---------------------------------------------------------------- | -------------------------------------------------------------------- |
| **[Cheat Engine](https://cheatengine.org)**                      | Memory scanner & debugger for single-player games                    |
| **[Game-Cheats-Manager](https://github.com/dyang886/Game-Cheats-Manager)** | Download and manage game trainers with ease              |
| **[JHenTai](https://github.com/jiangtian616/JHenTai)**           | Cross-platform manga reader for E-Hentai & ExHentai                  |
| **[LunaTranslator](https://github.com/HIllya51/LunaTranslator)** | A Visual Novel translation tool, with HOOK / OCR / clipboard support |
| **[MTool](https://mtool.app/)**                                  | A game translation and modding tool with free and paid tiers          |
| **[Watt-Toolkit](https://github.com/BeyondDimension/SteamTools)** | Open-source Steam multifunctional toolbox (Steam++)                  |
| **[Wemod-Patcher](https://github.com/k1tbyte/Wemod-Patcher)**    | Unlock WeMod Pro features for free                                   |

### 🤖 AI Tools

| App                                                                                  | Description                                                                       |
| ------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------- |
| **[llama.cpp](https://github.com/ggml-org/llama.cpp)**                               | Inference of LLaMA model in pure C/C++ (cpu/cuda/hip/opencl/vulkan/sycl variants) |
| **[Sakura-Launcher-GUI](https://github.com/PiDanShouRouZhouXD/Sakura_Launcher_GUI)** | A GUI Launcher for Sakura LLM                                                     |

**Note:** `llama.cpp` has multiple manifests here (cpu/cuda/hip/opencl/vulkan/sycl). Upstream official releases currently do not provide a CUDA 13.1 (cu131) build, so this bucket includes a separate `llama.cpp-cu131` package.

---

## 🚀 Quick Start

### Add this bucket

```powershell
scoop bucket add apeiraco https://github.com/apeiraco/scoop-bucket.git
```

### Verify installation

```powershell
scoop bucket list
```

### Install apps

```powershell
# Install without prefix (recommended)
scoop install cheat-engine

# Install with prefix (use only when there's a name conflict)
scoop install apeiraco/cheat-engine
```

### Update apps

```powershell
scoop update *
```

---

## ⚠️ Disclaimer

- Some apps may require **Administrator privileges**
- Game modification tools are intended for **single-player games only**
- Users are responsible for any consequences arising from the use of these tools
- **Only x64 architecture is guaranteed to work** - other architectures may not be supported

---

## 🤝 Contributing

Pull requests are welcome! Before submitting, please ensure:

- The software has a clear open-source license or freeware terms
- Valid `checkver` and `autoupdate` configurations are provided
- Manifests follow [Scoop App Manifests](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests) guidelines

---

## 📄 License

[The Unlicense](LICENSE) - Public Domain

**Note:** The licenses of individual software packages in this bucket are determined by their respective upstream repositories. Please refer to the original project's license for each application.
