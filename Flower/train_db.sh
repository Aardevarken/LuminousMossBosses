#!/bin/bash
my_dir=`dirname $0`

make $my_dir/manifest_db 
$my_dir/manifest_db
rm -f $my_dir/flower.vec
opencv_createsamples -vec $my_dir/flower.vec -info $my_dir/positive.manifest -w 20 -h 20
mkdir -p $my_dir/classifier
rm -f $my_dir/classifier/*
opencv_traincascade -data $my_dir/classifier -vec $my_dir/flower.vec -bg $my_dir/background.manifest -numPos 90 -numNeg 101 -numStages 25 -w 20 -h 20 -featureType HAAR
cp $my_dir/classifier/cascade.xml $my_dir/flower.xml
