RELEASE_KEY ?= signer@domain.tld

verify: check.sha256sum.asc check.sha256sum unpack
	cd delivery;\
	gpg --import release-signature-key.asc;\
	gpg --verify-files check.sha256sum.asc;\
	sha256sum -c check.sha256sum

unpack: artifact.tgz
	mkdir delivery
	tar xfz $< -C delivery


artifact.tgz: build check.sha256sum check.sha256sum.asc release-signature-key.asc
	tar cfz artifact.tgz $?

check.sha256sum.asc: check.sha256sum
	gpg --export --armor $(RELEASE_KEY) > release-signature-key.asc
	gpg --detach-sign -a $<

check.sha256sum: build
	sha256sum $(shell find build/ -type f) > check.sha256sum


build: clean
	@bash -c 'mkdir -p build/src/{a,b,c,d}; for f in build/src/{a,b,c,d}/{1..5}; do head -c8 </dev/urandom > $$f; done'

clean:
	rm -rf build check.sha256sum* release-signature-key.asc artifact.tgz delivery

