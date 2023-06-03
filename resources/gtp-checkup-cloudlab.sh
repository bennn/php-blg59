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

### count chaps (need patch)
### for X in gtp-checkup/benchmarks/*/*/main.rkt ; do echo "(require gtp-checkup/private/count-chaps) (count-chaps)" >> ${X}; done


## -- run past rackets, pre-8.7
#for VV in 6.11 6.10.1 6.9 6.8 6.7 6.6 6.5 6.4 6.3 6.2.1 6.1.1 6.0.1 ; do
#  wget https://download.racket-lang.org/installers/${VV}/racket-${VV}-src-builtpkgs.tgz
#  tar -xzf racket-${VV}-src-builtpkgs.tgz
#  mkdir racket-${VV}/src/build
#  cd racket-${VV}/src/build
#  ../configure && make && make install
#  cd ../../..
#  BIND="/users/ben_g/racket-${VV}/bin"
#  RACO="${BIND}/raco"
#  MAIN=main.rkt
#  ### ${RACO} pkg install --auto --clone require-typed-check ; git checkout 3103e8483ee9665bdeab8935a11bef2453d7fb42 ; 
#  cd require-typed-check; ${RACO} pkg install --auto ;
#  cd ../gtp-checkup;
#  ${RACO} pkg install --auto ;
#  PLTSTDERR="error info@gtp-checkup" ${BIND}/racket ${MAIN} ${BIND} >& ../output-${VV}.txt
#  cd ..
#  ./racket-${VV}/bin/raco pkg remove gtp-checkup require-typed-check
#  find gtp-checkup -name "compiled" | xargs rm -r
#  find require-typed-check -name "compiled" | xargs rm -r
#done
