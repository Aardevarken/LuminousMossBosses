#!/bin/bash
for i in $( ls positive ); do echo positive/$i 1 0 0 `identify -format "%wx%h" positive/$i | sed 's/x/ /'`; done > positive.manifest
for i in $( ls negative ); do echo negative/$i; done > negative.manifest
for i in $( ls background ); do echo background/$i; done > background.manifest
cat negative.manifest background.manifest > bg.manifest