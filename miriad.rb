require 'formula'

class Miriad < Formula
  homepage ''
  url 'https://www.cfa.harvard.edu/~pwilliam/miriad-macport/miriad-4.3.7.20131227.tar.gz'
  sha256 '39c614e3ad9e132231ccd215feea6abb054a8568'
  keg_only "This is just the way that MIRIAD works."

  #depends_on :x11
  #depends_on :fortran

  def install
    ENV.deparallelize
    ENV.no_optimization

    system "./configure", "--prefix=#{prefix}", "--with-telescope=carma"
    system "make"
    system "make", "install"
  end
end
