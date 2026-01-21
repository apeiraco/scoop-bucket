# AGENTS.md

_Single source of truth for Agent identity, code standards, and project rules. Symbolically linked by `.cursorrules`, `CLAUDE.md`, and `GEMINI.md`._

## Identity

**Language:**

- Chat: User's language (Chinese → Chinese, English → English)
- Code/Comments/Docs: English ONLY

**Style:** Concise, technical, action-oriented

## Code Standards

**General:**

- Comments: Explain _why_, not _what_
- Cross-references: Use `file:line` format
- For `bucket/*.json`, must follow [Scoop App Manifests](https://github.com/ScoopInstaller/Scoop/wiki/App-Manifests).
- Current bucket default architecture is 64bit. But following the scoop principle, if the application provides only a 32bit download, the architecture field is not required. In all other cases, architecture field is mandatory.
- `checkver`: Always use explicit object syntax with full URL (e.g., `"checkver": { "github": "https://github.com/owner/repo" }`). Never use the implicit shorthand `"checkver": "github"`.
- `license`: Prefer object syntax with `identifier` + `url` (e.g., `"license": { "identifier": "MIT", "url": "https://github.com/owner/repo/blob/main/LICENSE" }`). Omit `url` only when no upstream license file exists.

**Action Guidelines:**

- Local exploration (downloading installers, extracting archives, inspecting file structures) MUST be done in the `temp/` folder. Create it if it doesn't exist.
- To determine `extract_dir`, `persist`, `shortcuts`, `license`, etc., combine:
  1. Download and extract the installer/archive locally into `temp/` to inspect the actual file tree
  2. Read the upstream repository's README, docs, and source code for hints
  3. Form a hypothesis, then verify against the extracted contents

**Common Installer Patterns:**

| Type | Approach |
| --- | --- |
| **Zip / 7z** | Direct `url` — Scoop auto-extracts; use `extract_dir` if needed |
| **Single exe** | `url` with `#/name.exe` fragment to keep the filename |
| **Inno Setup** | `"innosetup": true` |
| **NSIS** | Append `#/dl.7z` to `url` — 7-Zip natively extracts NSIS; use `extract_dir` to pick target folder |
| **Electron NSIS** | `#/dl.7z` + `"extract_dir": "$PLUGINSDIR"` + `pre_install` to expand inner `app-64.7z` via `Expand-7zipArchive` |
| **Zip-wrapped NSIS** | `pre_install` with two `Expand-7zipArchive` calls (NSIS layer → `app-64.7z`) |
