#!/bin/bash
g++ -c flower.cpp
g++ flower.o `pkg-config --libs --cflags opencv` -o flower
