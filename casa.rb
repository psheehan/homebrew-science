require 'formula'

class Casa < Formula
  homepage 'http://casa.nrao.edu/'
  url 'https://casa.nrao.edu/download/distro/linux/release/el7/casa-release-5.0.0-218.el7.tar.gz', :using => :curl
  sha256 'cc279d738869114bd290750f199ad172b59e58a81bb18edd3d98f93876e585f2'
  version '5.0.0'
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
