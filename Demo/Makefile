ifeq ($(OS),Windows_NT)
	#mingw needs pkg-config installed for this not to be an issue
	LIBS=-lopencv_core249 -lopencv_highgui249 -lopencv_imgproc249
else
	LIBS=`pkg-config --libs --cflags opencv`
endif

CC=g++
CFLAGS=-c -Wall
EXECUTABLE=example
SOURCES=example.cpp
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
	./example IMG_2278.JPG
