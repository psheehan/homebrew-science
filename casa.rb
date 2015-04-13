require 'formula'

class Casa < Formula
  homepage 'http://casa.nrao.edu/'
  url 'https://svn.cv.nrao.edu/casa/linux_distro/release/el6/casa-release-4.3.1-el6.tar.gz', :using => :curl
  sha1 'a41999fbf649aaf60fd04f85de302a8912693320'
  version '4.3.1'

  option "with-system-xml", "Use the system version of xml rather than the one packaged with CASA."

  def install
    prefix.install Dir['*']

    if build.with? "system-xml"
        system "rm", "#{prefix}/lib64/libxml2.so.2"
        system "ln", "-sf", "/usr/lib64/libxml2.so.2.7.7", "#{prefix}/lib64/libxml2.so.2"
    end
  end
end
