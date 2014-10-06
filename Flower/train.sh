#!/bin/bash
opencv_createsamples -vec flower.vec -info positive.manifest -w 20 -h 20
rm classifier/*
opencv_traincascade -data classifier -vec flower.vec -bg bg.manifest -numPos 100 -numNeg 105 -numStages 20 -w 20 -h 20 -featureType HAAR
cp classifier/cascade.xml flower.xml
