# signer

Use it to sign files in a directory.

## test run

```
mkdir -p build/src/{a,b,c,d}
for f in $(ls build/src/{a,b,c,d}/{1..5}); do head -c 8 </dev/urandom > $f; done
sha256sum $(find build/ -type f)
```

> will take some time and then output:

```
c23330bf700376a8a4b0c8e3a3006be7a06bcda1c98e413f5c9d0ca30d7d78ba  build/src/c/5
6606751b08192fd4d0d4947409b608d653a4eb6278e01ca832eb69a90c828977  build/src/c/4
8fa8f3233d3db99173f161a5e7b7fa48e083d22030f51c8f92648b615fd49bba  build/src/c/1
ae0af30cfed9204b44eab35e5a39856a5a0bf5bf5fe08dcbbc174230f826eee6  build/src/c/2
777e721a7e3d156104650fb2bebc0991d8c80a64137eb0860c1d986a9aa4cf31  build/src/c/3
b68f99f59f18d5990bb58da29893bc75fb203e4d972c57fbd941125c9770c163  build/src/a/5
1bf2d11426a40d312d9268e4f69511d6a2c04efbfa5a40cbd30df4cd439eaa2b  build/src/a/4
061f8bfbc77db7c4edf4b664652d6d56130125eb11aefd390dceb3f8887ebb18  build/src/a/1
140264efd59632ca5c8b4780732e6eec29e610b5c675c1ecb47426bdea35b9bf  build/src/a/2
9b9cbf56231ff5cf8fa6aceb570d20738e93478e81a423f5fed2d12a3876653b  build/src/a/3
4ca1e903bde4f0c711af0d4cb028170e06a95ac86095525604c1919694764258  build/src/d/5
472a20b36acbb1f1828d2c806d7dcccea29053e84fd2c8d5ec40c7f2e61f63cb  build/src/d/4
7b7f101e409224a0a546ab69e43a5d3806d23c5509172563c750018fcfeb2f2a  build/src/d/1
51c04c1825d1b6a8f48b7bf61b54a75610f53e36f4094c6f3d3a1f2b4bded2c6  build/src/d/2
73466592c3161a26c57015cfe572b0f7c8fa61aa5f17b71ec1d5efc065df6397  build/src/d/3
59edfcbd4ef08e8a4ddb5a9742270f5e7283ae806bea2145d59bc25a26783c25  build/src/b/5
0fa90e3ac2c8d2002a79556b23612aaa035dc8582cb59a3220aaa5d4b7015491  build/src/b/4
7f82bdfdbac724b166f9f8e30427ba5584f534616a29f2f2a0219238de2a2d16  build/src/b/1
f952ea620a6714c417c043f5f6034a93a0db753e11060227e61553fce299edfc  build/src/b/2
d330614d618209b838db8f941ade064dc0721632ddfe6bdfd391b72dba918244  build/src/b/3
```

> similar at least.


write that into a file, like so:

```
sha256sum $(find build/ -type f) > checksums.sha256
```

To verify all checksums, you run:

```
$ sha256sum -c checksums.sha256
build/src/c/5: OK
build/src/c/4: OK
build/src/c/1: OK
build/src/c/2: OK
build/src/c/3: OK
build/src/a/5: OK
build/src/a/4: OK
build/src/a/1: OK
build/src/a/2: OK
build/src/a/3: OK
build/src/d/5: OK
build/src/d/4: OK
build/src/d/1: OK
build/src/d/2: OK
build/src/d/3: OK
build/src/b/5: OK
build/src/b/4: OK
build/src/b/1: OK
build/src/b/2: OK
build/src/b/3: OK
```

Now tamper with the artifact by adding a null byte to one file:

```
$ echo "\0" > build/src/a/1
$ sha256sum -c checksums.sha256
build/src/c/5: OK
build/src/c/4: OK
build/src/c/1: OK
build/src/c/2: OK
build/src/c/3: OK
build/src/a/5: OK
build/src/a/4: OK
build/src/a/1: FAILED
build/src/a/2: OK
build/src/a/3: OK
build/src/d/5: OK
build/src/d/4: OK
build/src/d/1: OK
build/src/d/2: OK
build/src/d/3: OK
build/src/b/5: OK
build/src/b/4: OK
build/src/b/1: OK
build/src/b/2: OK
build/src/b/3: OK
sha256sum: WARNING: 1 computed checksum did NOT match
```
