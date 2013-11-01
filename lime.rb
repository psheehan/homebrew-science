require 'formula'

class Lime < Formula
  homepage ''
  url 'http://www.nbi.dk/~brinch/LimePackage/LimePackage1.3.tar.gz'
  sha1 'a4192b72d9350103a73a49708b4d1f6c8fbbfcae'
  version '1.3'

  depends_on 'cfitsio'
  depends_on 'gsl'
  depends_on 'qhull'

  def install
    ENV.deparallelize
    ENV.no_optimization

    inreplace 'lime', '$PATHTOLIME', '`brew --prefix`/Cellar/lime/1.3/'
    inreplace 'Makefile' do |s|
        s.gsub! '/opt/local/', '`brew --prefix`/'
        s.gsub! '${PATHTOLIME}', '`brew --prefix`/Cellar/lime/1.3'
    end
    inreplace 'src/grid.c', '<qhull/', '<libqhull/'
    inreplace 'src/smooth.c', '<qhull/', '<libqhull/'
    inreplace 'src/writefits.c', '<cfitsio/', '<'

    bin.install('lime')
    prefix.install Dir['*']
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test LimePackage`.
    system "false"
  end
end
