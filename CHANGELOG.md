# Changelog

## 2026-11-03

### Added

- Add moonlight-web tool.

### Fixed

- Fixed Wand Enhancer source build.

## 2026-07-28

### Changed

- Adjusted LinguaGacha's Windows x64 archive layout and migrated persisted data to the new `userdata` directory.
- Deprecated the local llama.cpp variants in favor of the matching packages maintained by ScoopInstaller/Versions.
- Migrated WSL Dashboard to the portable x64 archive.
- Reworked Wand Enhancer to build its unsigned executable locally from tagged source, using shared mise and Visual Studio build utilities with explicit tool and component requirements.

### Fixed

- Allowed Wand Enhancer source builds to use the first mise executable on PATH without forcing a Scoop-managed installation, with `scoop install main/mise` as the primary missing-tool guidance.
- Made Dango Translator release-tag checks tolerate the upstream `Ver.` prefix.
- Followed LunaTranslator's renamed x64 archive.
- Made calibre-web autoupdate discover the revisioned Windows installer asset.
- Fixed MoveEpicGamesGames version checks for its prerelease-only release history.
- Switched LM Studio checkver to the current download-page metadata.
- Switched MTool checkver to its stable download metadata.
