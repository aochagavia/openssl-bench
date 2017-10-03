CXXFLAGS+=-g -Wall -Werror -O2

CPPFLAGS+=-I../openssl/include
LDFLAGS+=-L../openssl
LDLIBS+=-lssl -lcrypto -ldl -lpthread

bench: bench.cc
perf.data: bench
	perf record -F999 --call-graph dwarf -- ./bench ECDHE-RSA-AES128-GCM-SHA256
	perf script | ~/FlameGraph/stackcollapse-perf.pl | ~/FlameGraph/flamegraph.pl > perf-aes128-openssl.svg
	perf record -F999 --call-graph dwarf -- ./bench ECDHE-RSA-AES256-GCM-SHA384
	perf script | ~/FlameGraph/stackcollapse-perf.pl | ~/FlameGraph/flamegraph.pl > perf-aes256-openssl.svg
	perf record -F999 --call-graph dwarf -- ./bench ECDHE-RSA-CHACHA20-POLY1305
	perf script | ~/FlameGraph/stackcollapse-perf.pl | ~/FlameGraph/flamegraph.pl > perf-chacha-openssl.svg

clean:; rm -f bench *.o