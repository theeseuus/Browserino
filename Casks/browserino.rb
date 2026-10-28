cask "browserino" do
  version "1.1.18"
  sha256 "bf9b2b79e7c6bc6a41bca233c713fa0c5646e8dc0e2e3dc36adb0b50fd6dbf6d"

  url "https://github.com/theeseuus/Browserino/releases/download/v#{version}/Browserino.zip"
  name "Browserino"
  desc "Browserino is a tiny browser selector for MacOS written in SwiftUI"
  homepage "https://github.com/theeseuus/Browserino"

  auto_updates false
  depends_on macos: :ventura

  app "Browserino.app"

  uninstall quit: "xyz.alexstrnik.Browserino"

  zap trash: "~/Library/Preferences/xyz.alexstrnik.Browserino.plist"
end
