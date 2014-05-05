SRC=luaz.c

TARGET=zloader.so
CFLAGS=`pkg-config --cflags lua zlib` -std=gnu99
LDFLAGS=`pkg-config --libs lua zlib`

all:$(TARGET)

clean:
	rm *.o *.inc *.so

$(SRC): zloader.inc

.SUFFIXES: .c .o .inc .lua

.lua.inc:
	lua bin2c.lua $< err > $@

.c.o:
	cc -fPIC -c $< $(CFLAGS)

$(TARGET): $(SRC) unzip.o ioapi.o
	gcc -O3 -shared -fPIC $(SRC) $(CFLAGS) $(LDFLAGS) unzip.o ioapi.o -o $@
