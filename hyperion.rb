require 'formula'

class Hyperion < Formula
  homepage 'www.hyperion-rt.org'
  url 'https://pypi.python.org/packages/source/H/Hyperion/Hyperion-0.9.4.tar.gz'
  sha1 '01eee8bdcc73b075a252a6e13a315d1e31b6afab'

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
