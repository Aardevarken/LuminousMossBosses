#!/bin/bash
opencv_createsamples -vec flower.vec -info positive.manifest -w 20 -h 20
rm -f classifier/*
opencv_traincascade -data classifier -vec flower.vec -bg background.manifest -numPos 90 -numNeg 101 -numStages 25 -w 20 -h 20 -featureType HAAR
cp classifier/cascade.xml flower.xml
