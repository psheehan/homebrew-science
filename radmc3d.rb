require 'formula'

class Radmc3d < Formula
  homepage 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/'
  url 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/radmc-3d_v0.41_28.06.17.zip'
  sha256 'f7b65f1496117dda86cadaca6d042effb0d53ff4db3f7e85f581d20fe0f97b48'
  version '0.41_28.06.17'

  depends_on :fortran

  option "with-openmp", "Include OpenMP support for parallel processing."

  def patches 
    DATA
  end

  def install
    ENV.deparallelize

    if build.with? "openmp"
        inreplace 'version_0.40/src/Makefile', 'OPTIM = -O2', 'OPTIM = -O2 -fopenmp'
    end

    system "make", "-C", "version_0.41/src/"

    bin.install "version_0.41/src/radmc3d"
  end
end

__END__
diff --git a/version_0.41/src/main.f90 b/version_0.41/src/main.f90
index 6c66014..69fa16c 100644
--- a/version_0.41/src/main.f90
+++ b/version_0.41/src/main.f90
@@ -2336,6 +2336,12 @@ subroutine read_radmcinp_file()
      call parse_input_double ('camera_localobs_zenith@       ',camera_localobs_zenith)
      call parse_input_double ('camera_spher_cavity_relres@   ',camera_spher_cavity_relres)
 !     call parse_input_double ('camera_min_aspectratio@       ',camera_min_aspectratio)
+     call parse_input_integer('camera_scatsrc_allfreq@       ',idum)
+     if(idum.eq.0) then
+         camera_scatsrc_allfreq = .false.
+     else
+         camera_scatsrc_allfreq = .true.
+     endif
      call parse_input_double ('camera_min_dangle@            ',mindang)
      call parse_input_double ('camera_max_dangle@            ',camera_max_dangle)
      call parse_input_double ('camera_min_drr@               ',mindrr)
