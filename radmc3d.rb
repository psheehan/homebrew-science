require 'formula'

class Radmc3d < Formula
  homepage 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/'
  url 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/radmc-3d_v0.40_17.09.16.zip'
  sha256 '24647d73fc2cb5c61c99db4b53ca64ff136e8e707317e708e5f22a70e08d423c'
  version '0.40'

  depends_on :fortran

  option "with-openmp", "Include OpenMP support for parallel processing."

  def install
    ENV.deparallelize
    ENV.no_optimization

    if build.with? "openmp"
        inreplace 'version_0.40/src/Makefile', 'OPTIM = -O2', 'OPTIM = -O2 -fopenmp'
    end

    system "make", "-C", "version_0.40/src/"

    bin.install "version_0.40/src/radmc3d"
  end
end

__END__
