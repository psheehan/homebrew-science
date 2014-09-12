require 'formula'

class Casa < Formula
  homepage 'http://casa.nrao.edu/'
  url 'https://svn.cv.nrao.edu/casa/linux_distro/casapy-42.2.30986-1-64b.tar.gz', :using => :curl
  sha1 '2bc2ff0132e48a6dd831c55a023c789e110db4ed'
  version '4.2.22'

  def install
    prefix.install Dir['*']
  end
end
