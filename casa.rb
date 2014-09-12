require 'formula'

class Casa < Formula
  homepage 'http://casa.nrao.edu/'
  url 'https://svn.cv.nrao.edu/casa/linux_distro/casapy-42.2.30986-1-64b.tar.gz', :using => :curl
  sha1 '524ff56c0bfcb811bbbef9238f220b08192de17f'
  version '4.2.22'

  def install
    prefix.install Dir['*']
  end
end
