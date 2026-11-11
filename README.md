# WordCraft web (GitHub Pages)

This repository hosts the official [WordCraft](https://github.com/storytold/wordcraft) web (WebAssembly) build from the ArtCraft team and the WordCraft contributors, so we can open it in a browser from GitHub Pages.

**Live site:** https://antojitos-ahumados.github.io/wordcraft-web/

**Pinned version:** 0.17.0 (`v0.17.0` from [storytold/wordcraft](https://github.com/storytold/wordcraft/releases/tag/v0.17.0)).

The published site is the unmodified official `wordcraft-web-0.17.0.zip`, served from the `gh-pages` branch. WordCraft is alpha software. It needs a modern browser with WebGPU or WebGL2. Files you open stay in your browser; this site does not upload documents.

## License and credit

WordCraft is dual-licensed under [MIT](LICENSE-MIT) or [Apache-2.0](LICENSE-APACHE), at your option. Copyright (c) 2026 ArtCraft Team and the WordCraft contributors. Required notices are in [NOTICE](NOTICE). Bundled third-party material is listed in [ATTRIBUTION.md](ATTRIBUTION.md).

This repository does not include the ArtCraft wordmark or logos, which are trademarks of the ArtCraft Team.

Upstream project: [github.com/storytold/wordcraft](https://github.com/storytold/wordcraft) · [getartcraft.com/apps/wordcraft](https://getartcraft.com/apps/wordcraft)

## How to bump the version

From a clone of this repository, publish a newer official web zip to the `gh-pages` branch:

```sh
./scripts/publish-gh-pages.sh 0.18.0
```

The script downloads `wordcraft-web-<version>.zip` from the official `storytold/wordcraft` release, checks its SHA-256 against that release's `SHA256SUMS.txt`, and replaces the `gh-pages` branch.

An equivalent GitHub Actions workflow is in [`scripts/deploy-pages.yml`](scripts/deploy-pages.yml). Once that file is moved to `.github/workflows/deploy-pages.yml` and Pages is set to build from GitHub Actions, bumping is a one-line change to `WORDCRAFT_VERSION` in the workflow, then a push or a manual **Run workflow**.
