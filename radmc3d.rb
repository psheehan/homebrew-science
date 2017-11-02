require 'formula'

class Radmc3d < Formula
  homepage 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/'
  url 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/radmc-3d_v0.41_07.07.17.zip'
  sha256 '11dea10c3508dc5aaea68fad01fa9123fe62e490b1c8c0d603a78a4c08da05e9'
  version '0.41_107.07.17'

  depends_on 'gcc'
  depends_on 'glibc'

  def patches 
    DATA
  end

  def install
    ENV.deparallelize

    system "make", "-C", "version_0.41/src/"

    bin.install "version_0.41/src/radmc3d"
  end
end

__END__
diff --git a/version_0.41/src/camera_module.f90 b/version_0.41/src/camera_module.f90
index ec59d19..c363f0a 100644
--- a/version_0.41/src/camera_module.f90
+++ b/version_0.41/src/camera_module.f90
@@ -1,4 +1,5 @@
 module camera_module
+  !$ use omp_lib
   use rtglobal_module
   use amrray_module
   use dust_module
@@ -298,6 +299,10 @@ module camera_module
   !
   double precision :: camera_maxdphi = 0.d0
   !
+  ! OpenMP Parallellization:
+  ! Global variables used in subroutine calls within the parallel region which are threadprivate
+  !
+  !$OMP THREADPRIVATE(camera_intensity_iquv)
 contains
 
 
@@ -465,11 +470,13 @@ subroutine camera_init()
      write(stdo,*) 'ERROR in camera module: Could not allocate spectrum array.'
      stop
   endif
+  !$OMP PARALLEL
   allocate(camera_intensity_iquv(1:camera_nrfreq,1:4),STAT=ierr)
   if(ierr.ne.0) then
      write(stdo,*) 'ERROR in camera module: Could not allocate camera_intensity_iquv() array'
      stop
   endif
+  !$OMP END PARALLEL
   !
   ! Now allocate the image array for the rectangular images
   !
@@ -570,7 +577,9 @@ subroutine camera_partial_cleanup()
   if(allocated(camera_rect_image_iquv)) deallocate(camera_rect_image_iquv)
   if(allocated(camera_circ_image_iquv)) deallocate(camera_circ_image_iquv)
   if(allocated(camera_spectrum_iquv)) deallocate(camera_spectrum_iquv)
+  !$OMP PARALLEL
   if(allocated(camera_intensity_iquv)) deallocate(camera_intensity_iquv)
+  !$OMP END PARALLEL
   if(allocated(camera_xstop)) deallocate(camera_xstop)
   if(allocated(camera_ystop)) deallocate(camera_ystop)
   if(allocated(camera_zstop)) deallocate(camera_zstop)
@@ -2739,6 +2748,10 @@ recursive subroutine camera_compute_one_pixel(nrfreq,inu0,inu1,px,py,pdx,pdy,  &
   integer :: nrfreq,istar
   double precision :: intensity(nrfreq,1:4)
   double precision :: intensdum(nrfreq,1:4)
+  double precision :: intensdum11(nrfreq,1:4)
+  double precision :: intensdum12(nrfreq,1:4)
+  double precision :: intensdum13(nrfreq,1:4)
+  double precision :: intensdum14(nrfreq,1:4)
   double precision :: intensdum2(nrfreq,1:4)
   double precision :: px,py,pdx,pdy
   double precision :: x1,y1,dx1,dy1
@@ -2746,6 +2759,7 @@ recursive subroutine camera_compute_one_pixel(nrfreq,inu0,inu1,px,py,pdx,pdy,  &
   double precision :: celldxmin,dum1,factor,rmin
   integer :: nrrefine,idum,inu0,inu1,inu,ns,istar1,is
   logical :: flag,todo,donerefine
+  !$ integer OMP_get_thread_num
   !
   ! Check
   !
@@ -2788,7 +2802,11 @@ recursive subroutine camera_compute_one_pixel(nrfreq,inu0,inu1,px,py,pdx,pdy,  &
   !
   ! Increase the counter
   !
+  ! Need critical to get the sub-pixeling numbers correct, but slows down the
+  ! parallelization a lot. I would suggest not using. - Patrick Sheehan
+  !!!!!!$OMP CRITICAL
   camera_subpixeling_npixtot = camera_subpixeling_npixtot + 1
+  !!!!!!$OMP END CRITICAL
   !
   ! Check if we need to refine our pixel
   !
@@ -2806,27 +2824,48 @@ recursive subroutine camera_compute_one_pixel(nrfreq,inu0,inu1,px,py,pdx,pdy,  &
         dy1  = 0.5d0*pdy
         intensity(inu0:inu1,1:4) = 0.d0
         !
+        ! OPENMP PARALLELIZATION HERE TO SPEED THINGS UP.
+        !
+        !$OMP TASK PRIVATE(x1,y1) SHARED(intensdum11) &
+        !$OMP FIRSTPRIVATE(nrfreq,inu0,inu1,dx1,dy1,idum,istar)
         x1   = px-0.25d0*pdx
         y1   = py-0.25d0*pdy
-        call camera_compute_one_pixel(nrfreq,inu0,inu1,x1,y1,dx1,dy1,idum,intensdum,istar)
-        intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum(inu0:inu1,1:4)
+        call camera_compute_one_pixel(nrfreq,inu0,inu1,x1,y1,dx1,dy1,idum,intensdum11,istar)
+        !intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum11(inu0:inu1,1:4)
+        !$OMP END TASK
         !
+        !$OMP TASK PRIVATE(x1,y1) SHARED(intensdum12) &
+        !$OMP FIRSTPRIVATE(nrfreq,inu0,inu1,dx1,dy1,idum,istar)
         x1   = px+0.25d0*pdx
         y1   = py-0.25d0*pdy
-        call camera_compute_one_pixel(nrfreq,inu0,inu1,x1,y1,dx1,dy1,idum,intensdum,istar)
-        intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum(inu0:inu1,1:4)
+        call camera_compute_one_pixel(nrfreq,inu0,inu1,x1,y1,dx1,dy1,idum,intensdum12,istar)
+        !intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum12(inu0:inu1,1:4)
+        !$OMP END TASK
         !
+        !$OMP TASK PRIVATE(x1,y1) SHARED(intensdum13) &
+        !$OMP FIRSTPRIVATE(nrfreq,inu0,inu1,dx1,dy1,idum,istar)
         x1   = px-0.25d0*pdx
         y1   = py+0.25d0*pdy
-        call camera_compute_one_pixel(nrfreq,inu0,inu1,x1,y1,dx1,dy1,idum,intensdum,istar)
-        intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum(inu0:inu1,1:4)
+        call camera_compute_one_pixel(nrfreq,inu0,inu1,x1,y1,dx1,dy1,idum,intensdum13,istar)
+        !intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum13(inu0:inu1,1:4)
+        !$OMP END TASK
         !
+        !$OMP TASK PRIVATE(x1,y1) SHARED(intensdum14) &
+        !$OMP FIRSTPRIVATE(nrfreq,inu0,inu1,dx1,dy1,idum,istar)
         x1   = px+0.25d0*pdx
         y1   = py+0.25d0*pdy
-        call camera_compute_one_pixel(nrfreq,inu0,inu1,x1,y1,dx1,dy1,idum,intensdum,istar)
-        intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum(inu0:inu1,1:4)
+        call camera_compute_one_pixel(nrfreq,inu0,inu1,x1,y1,dx1,dy1,idum,intensdum14,istar)
+        !intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum14(inu0:inu1,1:4)
+        !$OMP END TASK
         !
+        !$OMP TASKWAIT
+        !
+        intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum11(inu0:inu1,1:4)
+        intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum12(inu0:inu1,1:4)
+        intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum13(inu0:inu1,1:4)
+        intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) + intensdum14(inu0:inu1,1:4)
         intensity(inu0:inu1,1:4) = intensity(inu0:inu1,1:4) * 0.25d0
+        !
         donerefine = .true.
      else
         !
@@ -2840,7 +2879,9 @@ recursive subroutine camera_compute_one_pixel(nrfreq,inu0,inu1,px,py,pdx,pdy,  &
      ! No refinement was done, so this pixel also counts as a "fine" pixel
      ! So increase that counter (this is just for diagnostics; it's non-essential)
      !
+     !!!!!!$OMP CRITICAL
      camera_subpixeling_npixfine = camera_subpixeling_npixfine + 1
+     !!!!!!$OMP END CRITICAL
   endif
   !
   ! Include stellar spheres
@@ -3129,6 +3170,7 @@ subroutine camera_make_rect_image(img,tausurf)
   character*80 :: strint
   integer :: iact,icnt,ilinesub
   logical :: redo
+  double precision :: seconds
   !
   ! If "tausurf" is set, then the purpose of this subroutine
   ! changes from being an imager to being a "tau=1 surface finder".
@@ -3822,6 +3864,7 @@ subroutine camera_make_rect_image(img,tausurf)
      ! If necessary, then do the scattering source functions at all
      ! frequencies beforehand.  WARNING: This can be a very large array!
      !
+     !$ seconds = omp_get_wtime()
      if(domc) then
         if(allocated(mc_frequencies)) deallocate(mc_frequencies)
         mc_nrfreq=camera_nrfreq
@@ -3862,6 +3905,7 @@ subroutine camera_make_rect_image(img,tausurf)
            stop 8762
         endif
      endif
+     !$ write(stdo,*)"Total elapsed time:",omp_get_wtime() - seconds;
      !
      ! Pre-compute which lines and which levels for line transfer may
      ! contribute to these wavelengths. Note that this only has to be
@@ -4155,6 +4199,12 @@ subroutine camera_make_rect_image(img,tausurf)
     integer :: inuu
     integer :: backup_nrrefine,backup_tracemode
     logical :: warn_tausurf_problem,flag_quv_too_big
+    integer :: id,nthreads
+    double precision :: seconds
+    integer :: pixel_count = 0
+    !$ integer OMP_get_num_threads
+    !$ integer OMP_get_thread_num
+    !$ integer OMP_get_num_procs
     !
     ! Reset some non-essential counters
     !
@@ -4170,7 +4220,23 @@ subroutine camera_make_rect_image(img,tausurf)
        !
        ! *** NEAR FUTURE: PUT OPENMP DIRECTIVES HERE (START) ***
        !
+       !$ seconds = omp_get_wtime()
+       !
+       !$OMP PARALLEL &
+       !
+       !!$ Local variables from this function.
+       !
+       !$OMP PRIVATE(px,py,id,nthreads,pixel_count)
+       !
+       !$ pixel_count = 0
+       !
+       !$ id=OMP_get_thread_num()
+       !$ nthreads=OMP_get_num_threads()
+       !$ write(stdo,*) 'Thread Nr',id,'of',nthreads,'threads in total'
        flag_quv_too_big = .false.
+       !
+       !$OMP DO COLLAPSE(2) SCHEDULE(dynamic)
+       !
        do iy=1,camera_image_ny
           do ix=1,camera_image_nx
              !
@@ -4220,14 +4286,24 @@ subroutine camera_make_rect_image(img,tausurf)
                 enddo
              endif
              !
+             !$ pixel_count = pixel_count + 1
           enddo
        enddo
+       !
+       !$OMP END DO
+       !
        if(flag_quv_too_big) then
           write(stdo,*) 'WARNING: While making an image, I found an instance of Q^2+U^2+V^2>I^2...'
        endif
        !
        ! *** NEAR FUTURE: PUT OPENMP DIRECTIVES HERE (FINISH) ***
        !
+       !$   write(stdo,*) 'Thread:',id,'raytraced:',pixel_count,'pixels'
+       !
+       !$OMP END PARALLEL
+       !
+       !$ write(stdo,*)"Elapsed time:",omp_get_wtime() - seconds;
+       !
     else
        !
        ! Find the tau=1 surface (or any tau=tausurf surface)
diff --git a/version_0.41/src/main.f90 b/version_0.41/src/main.f90
index 6c66014..ead03b9 100644
--- a/version_0.41/src/main.f90
+++ b/version_0.41/src/main.f90
@@ -2342,6 +2342,12 @@ subroutine read_radmcinp_file()
      call parse_input_integer('camera_interpol_jnu@          ',interpoljnu)
      call parse_input_double ('camera_maxdphi@               ',camera_maxdphi)
      call parse_input_integer('sources_interpol_jnu@         ',interpoljnu)
+     call parse_input_integer('camera_scatsrc_allfreq@       ',idum)
+     if(idum.eq.0) then
+         camera_scatsrc_allfreq = .false.
+     else
+         camera_scatsrc_allfreq = .true.
+     endif
 !     call parse_input_double ('lines_maxdoppler@             ',lines_maxdoppler)
      call parse_input_integer('lines_mode@                   ',lines_mode)
      call parse_input_integer('lines_autosubset@             ',iautosubset)
diff --git a/version_0.41/src/sources_module.f90 b/version_0.41/src/sources_module.f90
index b220a67..823a893 100644
--- a/version_0.41/src/sources_module.f90
+++ b/version_0.41/src/sources_module.f90
@@ -1,4 +1,5 @@
 module sources_module
+  !$ use omp_lib
   use rtglobal_module
   use amrray_module
   use dust_module
@@ -71,6 +72,9 @@ module sources_module
   double precision, allocatable :: sources_local_line_nup_end(:)
   double precision, allocatable :: sources_local_line_ndown_end(:)
 
+  !$OMP THREADPRIVATE(sources_dustdens,sources_dusttemp)
+  !!!!!!$OMP THREADPRIVATE(sources_dustkappa_a,sources_dustkappa_s)
+  !$OMP THREADPRIVATE(sources_alpha_a,sources_alpha_s)
 contains
 
 !-------------------------------------------------------------------
@@ -103,16 +107,20 @@ subroutine sources_init(nrfreq,frequencies,secondorder,doppcatch)
   ! Allocate the arrays for the dust 
   !
   if(rt_incl_dust) then
+     !$OMP PARALLEL
      allocate(sources_dustdens(1:dust_nr_species),STAT=ierr)
      if(ierr.ne.0) then
         write(stdo,*) 'ERROR in sources module: Could not allocate sources_dustdens() array'
         stop
      endif
+     !$OMP END PARALLEL
+     !$OMP PARALLEL
      allocate(sources_dusttemp(1:dust_nr_species),STAT=ierr)
      if(ierr.ne.0) then
         write(stdo,*) 'ERROR in sources module: Could not allocate sources_dusttemp() array'
         stop
      endif
+     !$OMP END PARALLEL
      allocate(sources_dustkappa_a(1:nrfreq,1:dust_nr_species),STAT=ierr)
      if(ierr.ne.0) then
         write(stdo,*) 'ERROR in sources module: Could not allocate sources_dustkappa_a()'
@@ -123,16 +131,20 @@ subroutine sources_init(nrfreq,frequencies,secondorder,doppcatch)
         write(stdo,*) 'ERROR in sources module: Could not allocate sources_dustkappa_s()'
         stop 
      endif
+     !$OMP PARALLEL
      allocate(sources_alpha_a(1:dust_nr_species),STAT=ierr)
      if(ierr.ne.0) then
         write(stdo,*) 'ERROR in sources module: Could not allocate sources_alpha_a()'
         stop 
      endif
+     !$OMP END PARALLEL
+     !$OMP PARALLEL
      allocate(sources_alpha_s(1:dust_nr_species),STAT=ierr)
      if(ierr.ne.0) then
         write(stdo,*) 'ERROR in sources module: Could not allocate sources_alpha_s()'
         stop 
      endif
+     !$OMP END PARALLEL
      !
      ! Get the dust opacities 
      !
@@ -308,12 +320,16 @@ end subroutine sources_init
 !-------------------------------------------------------------------
 subroutine sources_partial_cleanup()
   implicit none
+  !$OMP PARALLEL
   if(allocated(sources_dustdens)) deallocate(sources_dustdens)
   if(allocated(sources_dusttemp)) deallocate(sources_dusttemp)
+  !$OMP END PARALLEL
   if(allocated(sources_dustkappa_a)) deallocate(sources_dustkappa_a)
   if(allocated(sources_dustkappa_s)) deallocate(sources_dustkappa_s)
+  !$OMP PARALLEL
   if(allocated(sources_alpha_a)) deallocate(sources_alpha_a)
   if(allocated(sources_alpha_s)) deallocate(sources_alpha_s)
+  !$OMP END PARALLEL
   if(allocated(sources_align_mu)) deallocate(sources_align_mu)
   if(allocated(sources_align_orth)) deallocate(sources_align_orth)
   if(allocated(sources_align_para)) deallocate(sources_align_para)

