require 'formula'

class Miriad < Formula
  homepage ''
  url 'https://www.cfa.harvard.edu/~pwilliam/miriad-macport/miriad-4.3.7.20131227.tar.gz'
  sha256 'f987c616091b889c850623437886c304dfc058781822f8d5fe943d10d4527401'
  keg_only "This is just the way that MIRIAD works."

  depends_on 'gcc'

  def install
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", "--with-telescope=carma"
    system "make"
    system "make", "install"
  end
end
