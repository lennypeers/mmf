# Maintainer: lennypeers <lennypeers+git at protonmail>
pkgname=mmf
pkgver=0.2.2
pkgrel=1
pkgdesc="manual mac fan"
arch=(x86_64)
url="https://github.com/lennypeers/mmf"
license=(MIT)
depends=(bash udev)
makedepends=(git)
source=("git+https://github.com/lennypeers/mmf.git")
md5sums=('SKIP')

package() {
	cd "$srcdir/$pkgname"
	install -vDm0644 src/98-bifan.rules $pkgdir/etc/udev/rules.d/98-bifan.rules
	install -vDm0644 src/99-fan.rules $pkgdir/etc/udev/rules.d/99-fan.rules
	install -vDm0755 src/mmf.sh $pkgdir/usr/bin/mmf
}
