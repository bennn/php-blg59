wget https://download.racket-lang.org/installers/8.8/racket-8.8-src-builtpkgs.tgz
tar -xzf racket-8.8-src-builtpkgs.tgz
mkdir racket-8.8/src/build
cd racket-8.8/src/build
../configure && make && make install
cd ../../..
./racket-8.8/bin/raco pkg install --auto --clone gtp-benchmarks
./racket-8.8/bin/raco pkg install --auto --clone gtp-measure
echo 'PLTSTDERR="error info@gtp-measure" ./racket-8.8/bin/raco gtp-measure --output ./output/ manifest.rkt' > run.sh
echo "#lang gtp-measure/manifest\n#:config #hash(" >> manifest.rkt
echo "  (bin . \"$(pwd)/racket-8.8/bin\")" >> manifest.rkt
echo "  (cutoff . 10) (sample-factor . 9) (num-samples . 9)" >> manifest.rkt
echo "  (iterations . 8) (jit-warmup . 1 ))\n\n" >> manifest.rkt
for bm in gtp-benchmarks/benchmarks/*/ ; do
  # TODO deep-shallow-untyped
  echo "(\"$(pwd)/${bm}\" . typed-untyped)" >> manifest.rkt
done
