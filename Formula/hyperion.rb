require 'formula'

class Hyperion < Formula
  homepage 'www.hyperion-rt.org'
  head 'https://github.com/hyperion-rt/hyperion.git'

  depends_on 'hdf5@1.8'
  depends_on 'mpich'

  def install
    ENV.deparallelize
    ENV["HYPERION_HDF5_VERSION"] = "18"

    inreplace "Makefile.in", "FCMPI = @mpi_fc@ @extra_mpi@", 
        "FCMPI = @mpi_fc@ @extra_mpi@ -fallow-argument-mismatch"

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"

    inreplace 'Makefile', ' -g', ''

    system "make"
    system "make", "install"
  end
end
