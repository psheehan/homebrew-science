require 'formula'

class Radmc3d < Formula
  homepage 'http://www.ita.uni-heidelberg.de/~dullemond/software/radmc-3d/'
  head 'https://github.com/psheehan/radmc3d-2.0.git'
  version_scheme 2

  depends_on 'gcc'
  depends_on 'glibc' unless OS.mac?

  def install
    ENV.deparallelize

    system "make", "-C", "src/"

    bin.install "src/radmc3d"
  end
end

__END__
