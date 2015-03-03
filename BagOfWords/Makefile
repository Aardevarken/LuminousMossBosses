CFLAGS=-c -Wall

ifeq ($(OS),Windows_NT)
	LIBS=-lopencv_core249 -lopencv_highgui249 -lopencv_imgproc249 -lopencv_objdetect249
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S), Darwin)
		LIBS=`pkg-config --libs --cflags opencv`
		CFLAGS+=$(LIBS)
	endif
	ifeq ($(UNAME_S),Linux)
		LIBS=`pkg-config --libs --cflags opencv` 
	endif
endif

CC=g++

all: build_vocab_db build_vocab bow_train_db bow_train bow_test_db bow

build_vocab_db: build_vocab_db.o ../AlgTester/img_helper.o
	$(CC) build_vocab_db.o ../AlgTester/img_helper.o $(LIBS) -lmysqlcppconn -o $@

build_vocab: build_vocab.o
	$(CC) build_vocab.o $(LIBS) -o $@

bow_train_db: bow_train_db.o ../AlgTester/img_helper.o
	$(CC) bow_train_db.o ../AlgTester/img_helper.o $(LIBS) -lmysqlcppconn -o $@

bow_train: bow_train.o
	$(CC) bow_train.o $(LIBS) -o $@

bow_test_db: bow_test_db.o
	$(CC) bow_test_db.o $(LIBS) -lmysqlcppconn -o $@

bow: bow.o
	$(CC) bow.o $(LIBS) -o $@

.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -rf *o *~ build_vocab bow_train bow build_vocab_db bow_train_db bow_test_db
	
demo:
	./example IMG_1997.jpg
	./example IMG_1976.jpg
	./example IMG_2278.jpg
