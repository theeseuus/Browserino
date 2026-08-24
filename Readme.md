# Browserino

![Browserino](images/browserino.png?v2)

Browserino is a tiny browser selector for MacOS written in SwiftUI. Just set as default browser, assign shortcuts, and now you can choose in which application you want to open the link.

Inspired by great [Browserosaurus](https://github.com/will-stone/browserosaurus), but a little bit faster and smaller thanks to native code, and fixes annoying Electron bug.

# Installation

```bash
brew tap theeseuus/browserino https://github.com/theeseuus/Browserino
brew trust --cask theeseuus/browserino/browserino
brew install --cask theeseuus/browserino/browserino
```

Or download Browserino from the [releases page](https://github.com/theeseuus/Browserino/releases).

If you want to support the app, you can buy it on [Gumroad](https://alexstrnik.gumroad.com/l/browserino).

# Release checklist (theeseuus fork)

Local build/release artifacts (`build/`, `dist/`) are generated files and are **not** committed to git.

Use this on a machine with `fish` shell and repo write access:

1. `cd /Users/troymay/Documents/Programming/github-repos/browserino/Browserino`
2. Build and package both release asset names:

```fish
rm -rf dist build
xcodebuild -project Browserino.xcodeproj -scheme Browserino -configuration Release -derivedDataPath build CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build
set APP_PATH (find build -type d -name 'Browserino.app' -print -quit)
mkdir -p dist
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" dist/Browserino.zip
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" dist/Browserino-1.1.17.zip
```

3. Re-tag the exact commit for the release:

```fish
git tag -fa v1.1.17 (git rev-parse HEAD) -m "Browserino 1.1.17"
git push --force origin refs/tags/v1.1.17
```

4. Create or repair the GitHub release and upload both artifacts:

```fish
if gh release view v1.1.17 --repo theeseuus/Browserino >/dev/null 2>&1
  gh release upload v1.1.17 dist/Browserino.zip dist/Browserino-1.1.17.zip --clobber --repo theeseuus/Browserino
else
  gh release create v1.1.17 dist/Browserino.zip dist/Browserino-1.1.17.zip --verify-tag --generate-notes --repo theeseuus/Browserino
end
```

5. Validate the tap URL resolves before reinstalling:

```fish
set REPO theeseuus/Browserino
set TAG v1.1.17
curl -I "https://github.com/$REPO/releases/download/$TAG/Browserino.zip"
```

Then from any machine:

```fish
brew uninstall --cask theeseuus/browserino/browserino
brew tap theeseuus/browserino https://github.com/theeseuus/Browserino
brew trust --cask theeseuus/browserino/browserino
brew reinstall --cask theeseuus/browserino/browserino
```
