require 'formula'

class Miriad < Formula
  homepage ''
  url 'https://www.cfa.harvard.edu/~pwilliam/miriad-macport/miriad-4.3.7.20130915.tar.gz'
  sha1 'ea882fd993e808af98932e75f4990b97ea9f0669'
  keg_only "This is just the way that MIRIAD works."

  depends_on :x11
  depends_on :fortran

  def install
    ENV.deparallelize
    ENV.no_optimization

    system "./configure", "--prefix=#{prefix}", "--with-telescope=carma"
    system "make"
    system "make", "install"
  end
end
