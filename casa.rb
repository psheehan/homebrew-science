require 'formula'

class Casa < Formula
  homepage 'http://casa.nrao.edu/'
  url 'https://svn.cv.nrao.edu/casa/linux_distro/stable/casapy-stable-42.0.26465-001-64b.tar.gz', :using => :curl
  sha1 '6ddcffce471ad517b035d2d6a9ae5c4dd67ea985'
  version '4.1.0'

  def install
    prefix.install Dir['*']
  end
end
