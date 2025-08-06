CFLAGS+=-O2 -Ibuild/openssl/include

LIBS+=-Lbuild/openssl -lcrypto -ldl -lz

all: peervpn

peervpn: build/openssl/libcrypto.a peervpn.o
	$(CC) $(LDFLAGS) peervpn.o $(LIBS) -o $@
	strip peervpn

peervpn.o: peervpn.c

clean:
	rm -f peervpn peervpn.o

build/openssl/libcrypto.a:
	mkdir -p build; cd build && ( [ -d openssl ] || git clone --branch OpenSSL_1_0_2-stable --single-branch https://github.com/openssl/openssl.git )
	cd build/openssl && \
	git switch OpenSSL_1_0_2-stable && \
	git pull && \
	./config no-shared && \
	make clean && \
	make -j12
