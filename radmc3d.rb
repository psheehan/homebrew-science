require 'formula'

class Radmc3d < Formula
  homepage 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/'
  url 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/radmc-3d_v0.39_17.03.15.zip'
  sha1 '1dc6477f931a6e2e8bd2fc3f9db562f4b0812035'
  version '0.39'

  depends_on :fortran

  option "with-openmp", "Include OpenMP support for parallel processing."

  #patch :DATA
  #patch :p0, :DATA

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
diff --git a/version_0.38/src/montecarlo_module.f90 b/version_0.38/src/montecarlo_module.f90
index 075e1e5..e6961b1 100644
--- a/version_0.38/src/montecarlo_module.f90
+++ b/version_0.38/src/montecarlo_module.f90
@@ -7549,7 +7549,10 @@ subroutine pick_randomfreq_db(nspec,temp,mc_enerpart,inupick)
   if(dust_nr_species.gt.1) then 
      rn = ran2(iseed)*enercum(dust_nr_species+1)
      call hunt(enercum,dust_nr_species,rn,ispec)
-     if((ispec.lt.1).or.(ispec.gt.dust_nr_species)) stop 50209
+     if((ispec.lt.1).or.(ispec.gt.dust_nr_species)) then
+        write(stdo,*) 'WARNING: stop 50209 removed. Setting ispec = 1 on error.'
+        ispec = 1
+     endif
   else
      ispec = 1
   endif
@@ -8719,7 +8722,7 @@ subroutine modified_random_walk(cellx0,cellx1,pos,dir,energy,enerphot,     &
            if((r.lt.cellx0(1)).or.(r.gt.cellx1(1))) then
               write(stdo,*) 'ERROR in MRW: position out of r range'
               write(stdo,*) '  r = ',r,', range = ',cellx0(1),cellx1(1)
-              stop
+              notescaped = .false.
            endif
            if(idim.ge.2) then
               if((theta.lt.cellx0(2)).or.(theta.gt.cellx1(2))) then
