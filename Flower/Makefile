EXECUTABLE=GLflower
SOURCES=$(EXECUTABLE).cpp

CFLAGS=-c -Wall

ifeq ($(OS),Windows_NT)
	LIBS=-lopencv_core249 -lopencv_highgui249 -lopencv_imgproc249 -lopencv_objdetect249 -lglut32cu -lopengl32 -lglu32
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S), Darwin)
		LIBS=`pkg-config --libs --cflags opencv` 
		CFLAGS+=$(LIBS)
	endif
	ifeq ($(UNAME_S),Linux)
		LIBS=`pkg-config --libs --cflags opencv` -lglut -lGLU -lGL -lm 
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
	rm -rf *o $(EXECUTABLE)
	
demo:
	./example IMG_1997.jpg
	./example IMG_1976.jpg
	./example IMG_2278.jpg
