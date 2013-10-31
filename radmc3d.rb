require 'formula'

class Radmc3d < Formula
  homepage 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/'
  url 'http://kvothe.as.arizona.edu/~psheehan/repository/radmc3d-0.35.zip'
  sha1 'bf6959ee6043c3b4dbaf30d7ef816972aed4c83c'

  depends_on :fortran

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "make", "-C", "version_0.35/src/"
    system "mkdir", "-p", "#{prefix}/bin"
    system "cp", "version_0.35/src/radmc3d", "#{prefix}/bin/"
  end
end
