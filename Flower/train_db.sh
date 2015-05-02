#!/bin/bash
make manifest_db
./manifest_db
rm -f flower.vec
opencv_createsamples -vec flower.vec -info positive.manifest -w 20 -h 20
mkdir -p classifier
rm -f classifier/*
opencv_traincascade -data classifier -vec flower.vec -bg background.manifest -numPos 90 -numNeg 101 -numStages 25 -w 20 -h 20 -featureType HAAR
cp classifier/cascade.xml flower.xml
