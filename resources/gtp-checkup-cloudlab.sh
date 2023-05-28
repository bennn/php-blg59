## comment lines are for collecting memory use stats, need Racket BC
wget https://download.racket-lang.org/installers/8.8/racket-8.8-src-builtpkgs.tgz
tar -xzf racket-8.8-src-builtpkgs.tgz
mkdir racket-8.8/src/build
cd racket-8.8/src/build
../configure && make && make install
# ../configure --enable-bcdefault && make && make install
cd ../../..
./racket-8.8/bin/raco pkg install --auto --clone gtp-checkup
cd gtp-checkup
BIND="/users/ben_g/racket-8.8/bin"
RACO="${BIND}/raco"
MAIN=main.rkt
# for TM in benchmarks/typed*/main.rkt ; do echo "(let ((vv : (Mutable-Vectorof Integer) (make-vector 12 0))) (vector-set-performance-stats! vv) (writeln vv))" >> ${TM} ; done
# for UM in benchmarks/untyped/main.rkt ; do echo "(let ((vv (make-vector 12 0))) (vector-set-performance-stats! vv) (writeln vv))" >> ${UM} ; done
${RACO} make ${MAIN}
PLTSTDERR="error info@gtp-checkup" ${BIND}/racket ${MAIN} ${BIND} >& ../output-8.8.txt
cd ..
