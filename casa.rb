require 'formula'

class Casa < Formula
  homepage 'http://casa.nrao.edu/'
  url 'https://svn.cv.nrao.edu/casa/distro/linux/release/el5/casa-release-4.6.0-el5.tar.gz', :using => :curl
  sha256 'c35154cce48c7074a70956c6a457ac8bb319e7ef'
  version '4.6.0'
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
