require 'formula'

class Radmc3d < Formula
  homepage 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/'
  url 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/radmc-3d_v0.38_17.06.14.zip'
  sha1 '1753b34648f096b360e301920b16fed6348e518c'
  version '0.38'

  depends_on :fortran

  option "with-openmp", "Include OpenMP support for parallel processing."

  def install
    ENV.deparallelize
    ENV.no_optimization

    if build.with? "openmp"
        inreplace 'version_0.38/src/Makefile', 'OPTIM = -O2', 'OPTIM = -O2 -fopenmp'
    end

    # Hopefully fix a bug in the MRW part of the code.
    inreplace 'version_0.38/src/montecarlo_module.f90', 'mrw_cell_uses_mrw(ray_index) = .true.', '!mrw_cell_uses_mrw(ray_index) = .true.'
    #inreplace 'version_0.38/src/montecarlo_module.f90', '(r.lt.cellx0(1)).or.(r.gt.cellx1(1))', '(r.lt.cellx0(1)*(1.0-1d-11)).or.(r.gt.cellx1(1)*(1.0+1d-11))'
    #inreplace 'version_0.38/src/montecarlo_module.f90', "write(stdo,*) '  r = ',r,', range = ',cellx0(1),cellx1(1)", "write(stdo,*) '  r = ',r,', range = ',cellx0(1)*(1.0-1d-11),cellx1(1)*(1.0+1d-11)"

    system "make", "-C", "version_0.38/src/"

    bin.install "version_0.38/src/radmc3d"
  end
end
