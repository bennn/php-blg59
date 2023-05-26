wget https://download.racket-lang.org/installers/8.8/racket-8.8-src-builtpkgs.tgz
tar -xzf racket-8.8-src-builtpkgs.tgz
mkdir racket-8.8/src/build
cd racket-8.8/src/build
../configure && make && make install
cd ../../..
./racket-8.8/bin/raco pkg install --auto --clone gtp-checkup
cd gtp-checkup
BIND="/users/ben_g/racket-8.8/bin"
RACO="${BIND}/raco"
MAIN=main.rkt
${RACO} make ${MAIN}
PLTSTDERR="error info@gtp-checkup" ${BIND}/racket ${MAIN} ${BIND} >& ../output-8.8.txt
cd ..
