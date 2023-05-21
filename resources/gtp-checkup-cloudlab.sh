wget https://download.racket-lang.org/installers/8.8/racket-8.8-src-builtpkgs.tgz
tar -xzf racket-8.8-src-builtpkgs.tgz
mkdir racket-8.8/src/build
cd racket-8.8/src/build
../configure && make && make install
cd ../../..
./racket-8.8/bin/raco pkg install --auto --clone gtp-checkup
cd gtp-checkup
RACO="../racket-8.8/bin/raco"
MAIN=main.rkt
PLT_TR_NO_CONTRACT_OPTIMIZE=1 ${RACO} make ${MAIN} >& output.txt
PLT_TR_NO_CONTRACT_OPTIMIZE=1 PLTSTDERR="error info@gtp-checkup" ${RACO} test ${MAIN} >& output.txt
cd ..
