# Browserino Release Runbook (theeseuus fork)

This document has two workflows in fish shell syntax:

1. Full release flow (normal version bump / repack)
2. Hot-fix flow (release exists, only repair missing assets or wrong hash)

## 1) Full release flow

Use this when creating a new release or rebuilding artifacts from source.

```fish
cd /Users/troymay/Documents/Programming/github-repos/browserino/Browserino
git checkout main
git pull --ff-only origin main
rm -rf build dist

set VERSION 1.1.17
xcodebuild -project Browserino.xcodeproj -scheme Browserino -configuration Release -derivedDataPath build CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build
set APP_PATH (find build -type d -name 'Browserino.app' -print -quit)
if test -z "$APP_PATH"
  echo "Browserino.app not found"
  exit 1
end

mkdir -p dist
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" dist/Browserino-$VERSION.zip
ditto -c -k --sequesterRsrc --keepParent "$APP_PATH" dist/Browserino.zip
```

### Update tag and push

```fish
git tag -fa v$VERSION (git rev-parse HEAD) -m "Browserino $VERSION"
git push --force origin refs/tags/v$VERSION
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
set VERSION 1.1.17
set URL "https://github.com/$REPO/releases/download/v$VERSION/Browserino.zip"
curl -I $URL
```

Expect `HTTP/2 200`.

### Reinstall on machine(s)

```fish
brew update
brew reinstall --cask theeseuus/browserino/browserino
```

## 2) Hot-fix flow

Use this when a release exists but cask install fails with 404 because assets are missing/incorrect.

```fish
cd /Users/troymay/Documents/Programming/github-repos/browserino/Browserino
git checkout main
git pull --ff-only origin main

set VERSION 1.1.17
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
xcodebuild -project Browserino.xcodeproj -scheme Browserino -configuration Release -derivedDataPath build CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build
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

