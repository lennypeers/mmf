pkgname=mmf
pkgver=0.1
pkgrel=1
pkgdesc="manual mac fan"
arch=(x86_64)
url="https://github.com/lennypeers/mmf"
license=MIT
depends=(bash udev)
makedepends=(git)
source=("git+https://github.com/lennypeers/mmf.git")
md5sum=('SKIP')

package() {
	cd "$srcdir/$pkgname"
	install -vDm0644 9{8-bi,9-}fan.rules /etc/udev/rules.d/
	install -vDm0755 mmf /usr/bin/
}
