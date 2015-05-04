#!/bin/bash
my_dir=`dirname $0`
stamp=`date +'_%Y-%m-%d_%H:%M:%S'`

rm -f positive.manifest
rm -f background.manifest

make $my_dir/manifest_db
$my_dir/manifest_db

numpos=`wc -l < positive.manifest`
numneg=`wc -l < background.manifest`

#rm -f $my_dir/flower.vec
#opencv_createsamples -vec $my_dir/flower.vec -info positive.manifest -w 20 -h 20

#mkdir -p $my_dir/classifier
#rm -f $my_dir/classifier/*
#opencv_traincascade -data $my_dir/classifier -vec $my_dir/flower.vec -bg $my_dir/background.manifest -numPos $numpos -numNeg $numneg -numStages 25 -w 20 -h 20 -featureType HAAR
#cp $my_dir/classifier/cascade.xml $1/flower$stamp.xml

#rm -r $my_dir/classifier
#rm -f positive.manifest negative.manifest $my_dir/flower.vec
