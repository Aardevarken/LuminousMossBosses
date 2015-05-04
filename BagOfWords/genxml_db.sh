#!/bin/bash
my_dir=`dirname $0`

rm -f vocabulary.xml
$my_dir/build_vocab_db
cp vocabulary.xml $1/vocabulary.xml

rm -f silene.xml
$my_dir/bow_train_db
mv silene.xml $1/silene.xml
rm -f vocabulary.xml

