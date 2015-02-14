#!/bin/bash
for i in $( find pending/silene -type f ); do
  convert -thumbnail 100 $i "${i/pending/thumbnails}"
done
