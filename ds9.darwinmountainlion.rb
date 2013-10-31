require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Ds9Darwinmountainlion < Formula
  homepage ''
  url 'http://hea-www.harvard.edu/RD/ds9/download/darwinmountainlion/ds9.darwinmountainlion.7.2.tar.gz'
  sha1 '4d7d17fd619ef5aa2fc14618811207faad797d76'

  def install
      bin.install('ds9')
      bin.install('ds9.zip')
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test ds9.darwinmountainlion`.
    system "false"
  end
end
