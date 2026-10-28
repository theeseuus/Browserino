cask "browserino" do
  version "1.1.19"
  sha256 "bafc5ad60efea267721ae59df53161096a308872b0240f28cd78070837251315"

  url "https://github.com/theeseuus/Browserino/releases/download/v#{version}/Browserino.zip"
  name "Browserino"
  desc "Browserino is a tiny browser selector for macOS written in SwiftUI"
  homepage "https://github.com/theeseuus/Browserino"

  auto_updates false
  depends_on macos: :ventura

  app "Browserino.app"

  uninstall quit: "xyz.alexstrnik.Browserino"

  zap trash: "~/Library/Preferences/xyz.alexstrnik.Browserino.plist"
end
