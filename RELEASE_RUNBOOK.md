# Browserino Release Runbook (theeseuus fork)

Version: 1.3
Updated: 2026-10-28

This document has two workflows in fish shell syntax:

1. Full release flow (normal version bump / repack)
2. Hot-fix flow (release exists, only repair missing assets or wrong hash)

Important:
- `build/` and `dist/` are local artifacts and must **never** be committed.
- The local Fish workflow is the canonical release path. The GitHub release workflow is manual-only so it cannot overwrite a checksummed release asset when a tag is pushed.
- Never move or overwrite a published version tag during a normal release. If an artifact changes, publish a new patch version and checksum.
- Use cleanup commands after each release run and verify a clean working tree before commit.

## 1) Full release flow

Use this when creating a new release or rebuilding artifacts from source.

```fish
cd /Users/troymay/Documents/Programming/github-repos/browserino/Browserino
git checkout main
git pull --ff-only origin main
rm -rf build dist

set VERSION 1.1.18
xcodebuild -project Browserino.xcodeproj -scheme Browserino -configuration Release -destination 'generic/platform=macOS' -derivedDataPath build ARCHS='arm64 x86_64' ONLY_ACTIVE_ARCH=NO CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build
set APP_PATH (find build -type d -name 'Browserino.app' -print -quit)
if test -z "$APP_PATH"
  echo "Browserino.app not found"
  exit 1
end

mkdir -p dist
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" dist/Browserino-$VERSION.zip
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" dist/Browserino.zip
shasum -a 256 dist/Browserino.zip dist/Browserino-$VERSION.zip
```

Use the `Browserino.zip` checksum in `Casks/browserino.rb`. Confirm that the cask version and both Xcode `MARKETING_VERSION` values match `$VERSION`.

### Commit, tag, and push

```fish
git add Browserino.xcodeproj/project.pbxproj Casks/browserino.rb
git commit -m "Release Browserino $VERSION"
git tag -a v$VERSION -m "Browserino $VERSION"
git push origin v$VERSION
```

### Create or repair release assets

```fish
if gh release view v$VERSION --repo theeseuus/Browserino >/dev/null 2>&1
  gh release upload v$VERSION dist/Browserino.zip dist/Browserino-$VERSION.zip --clobber --repo theeseuus/Browserino
else
  gh release create v$VERSION dist/Browserino.zip dist/Browserino-$VERSION.zip --verify-tag --generate-notes --repo theeseuus/Browserino
end
```

### Validate download URL

```fish
set REPO theeseuus/Browserino
set VERSION 1.1.18
set URL "https://github.com/$REPO/releases/download/v$VERSION/Browserino.zip"
curl -I $URL
```

Expect `HTTP/2 200`.

Only after the release URL returns `200`, publish the cask update:

```fish
git push origin main
```

### Reinstall on machine(s)

```fish
brew update
brew reinstall --cask theeseuus/browserino/browserino
```

## 2) Hot-fix flow

Use this only when a release exists but an original, unchanged asset is missing. If rebuilding produces a different checksum, stop and create a new patch release instead of replacing the published artifact.

```fish
cd /Users/troymay/Documents/Programming/github-repos/browserino/Browserino
git checkout main
git pull --ff-only origin main

set VERSION 1.1.18
set REPO theeseuus/Browserino
set TAG v$VERSION
set FILE1 dist/Browserino.zip
set FILE2 dist/Browserino-$VERSION.zip
```

### Option A — re-upload from existing files

```fish
if test -f $FILE1; or test -f $FILE2
  if gh release view $TAG --repo $REPO >/dev/null 2>&1
    gh release upload $TAG $FILE1 $FILE2 --clobber --repo $REPO
  else
    echo "Release $TAG does not exist. Run the full flow or recreate the tag."
    exit 1
  end
else
  echo "dist artifacts missing. Build first (full release flow section) or restore artifacts."
  exit 1
end
```

### Option B — rebuild just the broken version (if artifacts are unavailable)

```fish
rm -rf build dist
xcodebuild -project Browserino.xcodeproj -scheme Browserino -configuration Release -destination 'generic/platform=macOS' -derivedDataPath build ARCHS='arm64 x86_64' ONLY_ACTIVE_ARCH=NO CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build
set APP_PATH (find build -type d -name 'Browserino.app' -print -quit)
if test -z "$APP_PATH"
  echo "Browserino.app not found"
  exit 1
end

mkdir -p dist
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" dist/Browserino.zip
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" dist/Browserino-$VERSION.zip
gh release upload $TAG dist/Browserino.zip dist/Browserino-$VERSION.zip --clobber --repo $REPO
```

### Verify and reinstall

```fish
set URL "https://github.com/$REPO/releases/download/$TAG/Browserino.zip"
curl -I $URL
brew update
brew reinstall --cask theeseuus/browserino/browserino
```

## Final cleanup (always)

```fish
rm -rf build dist
git status --short
```

If `git status --short` still shows `build/` or `dist/`, stop and clean them before committing anything.
