require 'formula'

class Casa < Formula
  homepage 'http://casa.nrao.edu/'
  url 'https://svn.cv.nrao.edu/casa/linux_distro/casapy-42.0.28322-021-1-64b.tar.gz', :using => :curl
  sha1 '524ff56c0bfcb811bbbef9238f220b08192de17f'
  version '4.2.21'

  def install
    prefix.install Dir['*']
  end
end
