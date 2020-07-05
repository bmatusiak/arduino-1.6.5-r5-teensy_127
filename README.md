# arduino-1.6.5-r5-teensy_127


Build Docker Image for building
```
make docker-build-toolchain
```

build firmware
```
make docker-build
```

build firmware from local files
```
make docker-build-local
```

Build firmware from fork(default is trustcrypto) and branch(default is master)
```
fork=trustcrypto branch=master make docker-build
```

Build firmware from tag
```
branch=v0.2-beta.8 make docker-build
```
Need to get the source for local dev?
```
make get-master
```
