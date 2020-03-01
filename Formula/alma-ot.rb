require 'formula'

class AlmaOt < Formula
  homepage ''
  url 'https://almascience.nrao.edu/almaot/cycle3/AlmaOT.tgz'
  sha256 'a02ee0750225d9ab6473450a54054421b67eb357'
  version '3.0'

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
