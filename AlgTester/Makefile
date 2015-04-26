EXECUTABLE=algTester
SOURCES=main.cpp identified.cpp glshapes.cpp detector.cpp

CFLAGS=-c -Wall
OCVFLAGS=`pkg-config --libs --cflags opencv`
ifeq ($(OS),Windows_NT)
	LIBS=-lopencv_core249 -lopencv_highgui249 -lopencv_imgproc249 -lopencv_objdetect249 -lglut32cu -lopengl32 -lglu32
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S), Darwin)
		LIBS=$(OCVFLAGS) -framework GLUT -framework OpenGL
		CFLAGS+=$(LIBS)
	endif
	ifeq ($(UNAME_S),Linux)
		LIBS=$(OCVFLAGS) -lglut -lGLU -lGL -lm 
	endif
endif

CC=g++
OBJECTS=$(SOURCES:.cpp=.o)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) $(LIBS) -o $@

.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -rf *o $(EXECUTABLE) test test_db findflowers bow_probability

demo1:
	algTester samples/IMG_1997.jpg 40
demo2:
	algTester samples/Silene_acaulis_Kalk-Polsternelke.jpg 40
	
test:
	g++ detector_test.cpp identified.cpp detector.cpp img_helper.cpp $(OCVFLAGS) -o test

test_db:
	g++ detector_test_db.cpp identified.cpp detector.cpp img_helper.cpp $(OCVFLAGS) -lmysqlcppconn -o test_db

bow:
	g++ bow_probability.cpp detector.cpp img_helper.cpp identified.cpp $(OCVFLAGS) -o bow_probability

flowers:
	g++ findflowers.cpp detector.cpp img_helper.cpp identified.cpp $(OCVFLAGS) -o findflowers