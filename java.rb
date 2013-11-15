require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
#                /home/psheehan/Documents/Programs/.linuxbrew/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Java < Formula
  homepage ''
  url 'http://javadl.sun.com/webapps/download/AutoDL?BundleId=81812'
  sha1 '729cbee2591a5b429f4fa9272db6e988371b7923'
  version '7.0'

  # depends_on 'cmake' => :build
  #depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
      prefix.install Dir['*']
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test AutoDL?BundleId=`.
    system "false"
  end
end
