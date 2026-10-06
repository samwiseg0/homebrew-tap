class Iairport < Formula
  desc "Wi-Fi roaming and link diagnostics for macOS"
  homepage "https://github.com/samwiseg0/iAirport"
  url "https://github.com/samwiseg0/iAirport/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "14655bc6739449a525aa4b99b71a83732be5fcc86344935fc9fcb169720091f1"
  license "MIT"
  head "https://github.com/samwiseg0/iAirport.git", branch: "master"

  depends_on macos: :sonoma

  def install
    # The app bundle is required. macOS only grants Location to a bundle.
    system "make", "bundle", "SWIFT_BUILD_FLAGS=--disable-sandbox"
    libexec.install "build/iairport.app"
    bin.install_symlink libexec/"iairport.app/Contents/MacOS/iairport"
  end

  def caveats
    <<~EOS
      The first run asks for Location permission. Click Allow so iairport
      can read the SSID and BSSID. The grant is tied to the installed
      binary, so each upgrade asks once more. The first roam asks for
      Notifications permission once, so the banner can carry the icon.

      Keep one install. If you built from source with `make install`
      before, run `sudo make uninstall` in that clone. If no prompt
      appears, quit any other running copy of iairport and run again.

      Some managed Macs mark app bundles outside /Applications
      launch-disabled, and the Location toggle turns itself off again.
      Homebrew keeps the bundle in the Cellar, so on those Macs build
      from a clone with `sudo make install APPINSTALLDIR=/Applications`.
    EOS
  end

  test do
    assert_match "iairport [options]", shell_output("#{bin}/iairport --help")
  end
end
