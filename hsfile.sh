#/bin/bash
set -x
ghc -odir dist/watched -hidir dist/watched -no-user-package-db -package-db .cabal-sandbox/x86_64-osx-ghc-7.8.3-packages.conf.d -isrc -idist/build/autogen -isrc/exec  $1
set +x