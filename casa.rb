require 'formula'

class Casa < Formula
  homepage 'http://casa.nrao.edu/'
  url 'https://svn.cv.nrao.edu/casa/linux_distro/stable/casapy-stable-42.0.26465-011-64b.tar.gz', :using => :curl
  sha1 '76180f90f0ac4ed75b19e260351b3e0bffae2e02'
  version '4.2.11'

  def install
    prefix.install Dir['*']
  end
end
