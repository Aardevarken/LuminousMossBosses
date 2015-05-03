#!/bin/bash
my_dir=`dirname $0`
stamp=`date +'_%Y-%m-%d_%H:%M:%S'`

rm -f vocabulary.xml
make $my_dir/build_vocab_db
$my_dir/build_vocab_db
cp vocabulary.xml $1/vocabulary$stamp.xml

rm -f silene.xml
make $my_dir/bow_train_db
$my_dir/bow_train_db
mv silene.xml $1/silene$stamp.xml
rm -f vocabulary.xml

