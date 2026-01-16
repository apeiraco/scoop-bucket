# 🚚 Scoop-Apeiraco

> _收录那些官方仓库不会接纳的非主流软件_

精选主流 bucket 忽略的实用工具——开发者工具、极客利器、ACGN 应用等。

[![Excavator](https://github.com/apeiraco/scoop-bucket/actions/workflows/excavator.yml/badge.svg)](https://github.com/apeiraco/scoop-bucket/actions/workflows/excavator.yml)
[![License](https://img.shields.io/badge/license-Unlicense-blue)](LICENSE)

**[🇬🇧 English](README.md)**

---

## 📦 软件目录

### 💻 开发者工具

| 软件                                                      | 描述                                                |
| --------------------------------------------------------- | --------------------------------------------------- |
| **[fresh](https://github.com/sinelaw/fresh)**             | 开箱即用的终端文本编辑器                            |
| **[ut](https://github.com/ksdme/ut)**                     | 快速轻量的 CLI 工具集                               |
| **[seaweedfs](https://github.com/seaweedfs/seaweedfs)**   | 高性能分布式存储系统                                |
| **[minio (archive)](https://github.com/minio/minio)**     | 高性能对象存储服务器（已归档版本，包含 WebUI 管理） |
| **[minio-client (archive)](https://github.com/minio/mc)** | MinIO 对象存储命令行客户端（已归档版本）            |

### 🔧 极客工具

| 软件                                                                          | 描述                                  |
| ----------------------------------------------------------------------------- | ------------------------------------- |
| **[ContextMenuManager](https://bluepointlilac.github.io/ContextMenuManager)** | Windows 右键菜单管理器                |
| **[Dism++](https://github.com/Chuyu-Team/Dism-Multi-language)**               | 强大的 Windows 系统精简优化工具       |
| **[UEFIExtract](https://github.com/LongSoft/UEFITool)**                       | UEFI 固件镜像提取工具（命令行版）     |
| **[UEFIFind](https://github.com/LongSoft/UEFITool)**                          | UEFI 固件镜像查看与编辑工具（新引擎） |

### 🎌 ACGN 工具

| 软件                                                             | 描述                                                        |
| ---------------------------------------------------------------- | ----------------------------------------------------------- |
| **[Cheat Engine](https://cheatengine.org)**                      | 经典内存扫描器与游戏调试工具                                |
| **[MoveEpicGamesGames](https://github.com/MinshuG/MoveEpicGamesGames)** | Epic Games 游戏迁移/备份工具                    |
| **[Game-Cheats-Manager](https://github.com/dyang886/Game-Cheats-Manager)** | 游戏修改器下载管理器                             |
| **[Game-Save-Manager](https://github.com/dyang886/Game-Save-Manager)** | 游戏存档备份与恢复管理工具                         |
| **[JHenTai](https://github.com/jiangtian616/JHenTai)**           | E-Hentai / ExHentai 跨平台漫画阅读器                        |
| **[LinguaGacha](https://github.com/neavo/LinguaGacha)**          | AI 驱动的次世代文本翻译器，支持小说、游戏、字幕内容翻译      |
| **[LunaTranslator](https://github.com/HIllya51/LunaTranslator)** | 强大的 Galgame 翻译工具，支持 Hook/OCR/剪贴板等多种翻译方式 |
| **[MTool](https://mtool.app/)**                                  | 游戏翻译与修改工具，提供免费基础功能与付费高级功能          |
| **[Watt-Toolkit](https://github.com/BeyondDimension/SteamTools)** | Steam++ 开源多功能工具箱                                  |
| **[Wemod-Patcher](https://github.com/k1tbyte/Wemod-Patcher)**    | WeMod Pro 功能解锁补丁                                      |

### 🤖 AI 工具

| 软件                                                                                 | 描述                                                                   |
| ------------------------------------------------------------------------------------ | ---------------------------------------------------------------------- |
| **[llama.cpp](https://github.com/ggml-org/llama.cpp)**                               | 纯 C/C++ 实现的 LLaMA 推理工具（cpu/cuda/hip/opencl/vulkan/sycl 变体） |
| **[Sakura-Launcher-GUI](https://github.com/PiDanShouRouZhouXD/Sakura_Launcher_GUI)** | SakuraLLM 的图形化启动器                                               |

**说明：** 本仓库提供 `llama.cpp` 的多个变体清单（cpu/cuda/hip/opencl/vulkan/sycl）。上游官方发布目前没有 CUDA 13.1（cu131）版本，因此这里单独提供了 `llama.cpp-cu131` 包。

---

## 🚀 快速开始

### 添加 Bucket

```powershell
scoop bucket add apeiraco https://github.com/apeiraco/scoop-bucket.git
```

### 验证添加

```powershell
scoop bucket list
```

### 安装软件

```powershell
# 不带前缀安装（推荐）
scoop install cheat-engine

# 带前缀安装（仅在名称冲突时使用）
scoop install apeiraco/cheat-engine
```

### 更新软件

```powershell
scoop update *
```

---

## ⚠️ 使用须知

- 部分软件可能需要**管理员权限**运行
- 游戏修改工具请仅用于**单机游戏**
- 使用这些工具产生的任何后果由用户自行承担
- **仅保证 x64 架构可用** - 其他架构可能不受支持

---

## 🤝 参与贡献

欢迎提交 Pull Request！提交前请确保：

- 软件有明确的开源许可或免费使用授权
- 提供有效的 `checkver` 和 `autoupdate` 配置
- 遵循 [Scoop App Manifests](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests) 规范
- 除非应用仅提供 32 位下载，否则必须声明 `architecture` 字段
- `checkver` 必须使用显式对象语法（如 `"checkver": { "github": "https://github.com/owner/repo" }`）

---

## 📄 许可证

[The Unlicense](LICENSE) - 公共领域

**注意：** 本仓库中具体软件的许可证以上游仓库为准，请参考各软件原始项目的许可证声明。
