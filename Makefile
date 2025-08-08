
default: rars.jar rars-flatlaf.sh

SOURCES=$(shell find -L src/ -type f)

rars.jar: $(SOURCES)
	./build-jar.sh

rars-flatlaf.jar: rars.jar
	./build-jar-flatlaf.sh

clean:
	rm -f rars.jar
	rm -rf build

