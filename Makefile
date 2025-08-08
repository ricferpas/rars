
default: rars.jar

SOURCES=$(shell find -L src/ -type f)

rars.jar: $(SOURCES)
	./build-jar.sh

clean:
	rm -f rars.jar
	rm -rf build

