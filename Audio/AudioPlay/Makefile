
CROSS_COMPILE=        ../../mips-gcc472-glibc216-64bit/bin/mips-linux-gnu-

CC = $(CROSS_COMPILE)gcc
CPLUSPLUS = $(CROSS_COMPILE)g++
LD = $(CROSS_COMPILE)ld
AR = $(CROSS_COMPILE)ar cr
STRIP = $(CROSS_COMPILE)strip

CFLAGS = $(INCLUDES) -O2 -Wall -march=mips32r2

CFLAGS += -muclibc
LDFLAG += -muclibc

SDK_LIB_DIR = uclibc

SDK_INC_DIR = ../../v4l2rtspserver-master/inc/

INCLUDES = -I$(SDK_INC_DIR)

LDFLAG += -Wl,-gc-sections

LIBS=../../v4l2rtspserver-master/uclibc/libimp.so ../../v4l2rtspserver-master/uclibc/libalog.so
all: 	audioplay

audioplay: audioplay.o
	$(CPLUSPLUS) $(LDFLAG) -o $@ $^ $(LIBS) -lpthread -lm -lrt
	$(STRIP) $@



%.o:%.c 
	$(CC) -c $(CFLAGS) $< -o $@

clean:
	rm -f *.o *~

distclean: clean
	rm -f $(SAMPLES)
