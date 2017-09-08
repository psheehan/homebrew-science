require 'formula'

class Radmc3d < Formula
  homepage 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/'
  url 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/radmc-3d_v0.41_28.06.17.zip'
  sha256 'f7b65f1496117dda86cadaca6d042effb0d53ff4db3f7e85f581d20fe0f97b48'
  version '0.41_28.06.17'

  depends_on :fortran

  option "with-openmp", "Include OpenMP support for parallel processing."

  def install
    ENV.deparallelize
    ENV.no_optimization

    if build.with? "openmp"
        inreplace 'version_0.40/src/Makefile', 'OPTIM = -O2', 'OPTIM = -O2 -fopenmp'
    end

    system "make", "-C", "version_0.40/src/"

    bin.install "version_0.41/src/radmc3d"
  end
end

__END__
