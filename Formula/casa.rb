require 'formula'

class Casa < Formula
  homepage 'http://casa.nrao.edu/'
  url 'https://casa.nrao.edu/download/distro/casa/release/rhel/casa-6.1.0-118.tar.xz', :using => :curl
  sha256 '08dfeeefed56b057f0c62f162848c1e352feb5519b8f3fd4be49944a3bffe13c'
  version '6.1.0'
  keg_only 'Because it comes with a lot of preinstalled libraries I dont want to link'

  option "with-system-xml", "Use the system version of xml rather than the one packaged with CASA."

  def install
    prefix.install Dir['*']

    if build.with? "system-xml"
        system "rm", "#{prefix}/lib64/libxml2.so.2"
        system "ln", "-sf", "/usr/lib64/libxml2.so.2.7.7", "#{prefix}/lib64/libxml2.so.2"
    end
  end
end
