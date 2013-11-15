require 'formula'

class AlmaOt < Formula
  homepage ''
  url 'https://almascience.nrao.edu/almaot/cycle2/AlmaOT.tgz'
  sha1 'b9991ece3784d4251a03f55e2e4a5316038f00b7'
  version '2.0'

  def install
    inreplace 'setup/Setup-Linux.sh', '$PWD', "#{HOMEBREW_PREFIX}/Cellar/alma-ot/2.0/"
    inreplace 'setup/Setup-Linux.sh', '!=', '=='
    inreplace 'setup/Setup-Linux.sh', 'setup/$3', '$INSTALLATION_DIRECTORY/setup/$3'
    inreplace 'setup/Setup-Linux.sh', '=$1', '=$INSTALLATION_DIRECTORY/$1'
    prefix.install Dir['*']
    system 'sh', "#{prefix}/setup/Setup-Linux.sh"
    bin.install "#{prefix}/ALMA-OT.sh"
  end
end
