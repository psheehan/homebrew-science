require 'formula'

class Radmc3d < Formula
  homepage 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/'
  url 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/radmc-3d_v0.40_17.09.16.zip'
  sha128 '7d36839054ad134580bc79bf51172fc0d4688bac'
  version '0.40'

  depends_on :fortran

  option "with-openmp", "Include OpenMP support for parallel processing."

  def install
    ENV.deparallelize
    ENV.no_optimization

    if build.with? "openmp"
        inreplace 'version_0.39/src/Makefile', 'OPTIM = -O2', 'OPTIM = -O2 -fopenmp'
    end

    system "make", "-C", "version_0.39/src/"

    bin.install "version_0.39/src/radmc3d"
  end
end

__END__
