CC = gcc
CFLAGS = -g -O2 -Wall
SHARED := -fPIC --shared
LUA_CLIB_PATH ?= luaclib
TARGET = timesp.so

.PHONY : all clean

all : $(TARGET)

$(TARGET) : timesp.c
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@

clean :
	rm -f $(TARGET)
