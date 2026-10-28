# Browserino

Documentation version: 1.1

Updated: 2026-10-28

![Browserino](images/browserino.png?v2)

Browserino is a tiny browser selector for macOS written in SwiftUI. Set it as your default browser, assign shortcuts, and choose which application should open each link.

## About this fork

This is a personal maintenance fork of [AlexStrNik/Browserino](https://github.com/AlexStrNik/Browserino), created to keep Browserino working for our own use after active upstream maintenance stopped.

Compared with the original repository, this fork:

- provides its own Homebrew tap and release artifacts;
- keeps the cask and application compatible with current Homebrew and macOS changes; and
- includes small practical fixes we need, such as optional removal of UTM tracking parameters before a URL is opened.

The repository is public in case these fixes are useful to other Browserino users. It is not an official continuation of the original project or a supported product: maintenance follows our own needs, and no response time, compatibility promise, or user support is guaranteed. Useful issue reports and focused pull requests are still welcome.

The fork remains available under the GNU GPL v3 licence and preserves the original project history and attribution.

Inspired by great [Browserosaurus](https://github.com/will-stone/browserosaurus), but a little bit faster and smaller thanks to native code, and fixes annoying Electron bug.

# Installation

```fish
brew tap theeseuus/browserino https://github.com/theeseuus/Browserino
brew trust --cask theeseuus/browserino/browserino
brew install --cask theeseuus/browserino/browserino
```

Or download Browserino from the [releases page](https://github.com/theeseuus/Browserino/releases).

# Maintaining releases

The Fish-compatible release procedure, including artifact cleanup and the hot-fix flow, is documented in [RELEASE_RUNBOOK.md](RELEASE_RUNBOOK.md). Local `build/` and `dist/` artifacts must not be committed.
