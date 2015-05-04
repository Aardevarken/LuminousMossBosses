#!/bin/bash
for i in $( ls positive ); do echo positive/$i 1 0 0 `identify -format "%wx%h" positive/$i | sed 's/x/ /'`; done > positive.manifest
for i in $( ls background ); do echo background/$i; done > background.manifest
for i in $( ls /work/pics/random ); do echo /work/pics/random/$i; done >> background.manifest
