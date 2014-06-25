require 'formula'

class Radmc3d < Formula
  homepage 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/'
  url 'http://kvothe.as.arizona.edu/~psheehan/public_html/repository/radmc3d-0.38.zip'
  sha1 '1753b34648f096b360e301920b16fed6348e518c'

  depends_on :fortran

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "make", "-C", "version_0.38/src/"
    system "mkdir", "-p", "#{prefix}/bin"
    system "cp", "version_0.38/src/radmc3d", "#{prefix}/bin/"
  end
end
