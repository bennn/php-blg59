wget https://download.racket-lang.org/installers/8.8/racket-8.8-src-builtpkgs.tgz
tar -xzf racket-8.8-src-builtpkgs.tgz
mkdir racket-8.8/src/build
cd racket-8.8/src/build
../configure && make && make install
cd ../../..
./racket-8.8/bin/raco pkg install --auto --clone gtp-checkup
make all >& output.txt
