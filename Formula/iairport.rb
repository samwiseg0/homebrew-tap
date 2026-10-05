class Iairport < Formula
  desc "Wi-Fi roaming and link diagnostics for macOS"
  homepage "https://github.com/samwiseg0/iAirport"
  url "https://github.com/samwiseg0/iAirport/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "710cec7ee40f0de7ec3168bddde6b8d21663966b6c05149f1b50e475f0cbd7a5"
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
      binary, so each upgrade asks once more.

      Keep one install. If you built from source with `make install`
      before, run `sudo make uninstall` in that clone. If no prompt
      appears, quit any other running copy of iairport and run again.
    EOS
  end

  test do
    assert_match "iairport [options]", shell_output("#{bin}/iairport --help")
  end
end
