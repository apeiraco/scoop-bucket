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
