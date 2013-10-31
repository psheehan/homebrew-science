require 'formula'

class Hyperion < Formula
  homepage 'www.hyperion-rt.org'
  url 'https://pypi.python.org/packages/source/H/Hyperion/hyperion-0.9.2.tar.gz'
  sha1 'a4321a9ce695c477176622edd1bf5646bfdc7dce'

  depends_on 'hdf5' => '--enable-fortran'
  depends_on 'mpich2'

  def install
    ENV.deparallelize
    ENV.no_optimization
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
