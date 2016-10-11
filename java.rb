require 'formula'

class Java < Formula
  homepage ''
  url 'http://javadl.sun.com/webapps/download/AutoDL?BundleId=81812'
  sha256 '729cbee2591a5b429f4fa9272db6e988371b7923'
  version '7.0'

  def install
      prefix.install Dir['*']
  end
end
