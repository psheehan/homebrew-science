require 'formula'

class AlmaOt < Formula
  homepage ''
  url 'https://almascience.nrao.edu/almaot/cycle2/AlmaOT.tgz'
  sha1 'b9991ece3784d4251a03f55e2e4a5316038f00b7'
  version '2.0'

  # depends_on 'cmake' => :build
  #depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    # Remove unrecognized options if warned by configure
    inreplace 'setup/Setup-Linux.sh', '$PWD', '`brew --prefix`/Cellar/alma-ot/2.0/'
    inreplace 'setup/Setup-Linux.sh', '!=', '=='
    inreplace 'setup/Setup-Linux.sh', 'setup/$3', '$INSTALLATION_DIRECTORY/setup/$3'
    inreplace 'setup/Setup-Linux.sh', '=$1', '=$INSTALLATION_DIRECTORY/$1'
    prefix.install Dir['*']
    system 'sh', "#{prefix}/setup/Setup-Linux.sh"
    bin.install "#{prefix}/ALMA-OT.sh"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test alma-ot`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "--version"`.
    system "false"
  end
end
