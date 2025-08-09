default: rars.jar rars-flatlaf.jar

SOURCES=$(shell find -L src/ -type f)

rars.jar: $(SOURCES)
	./build-jar.sh

rars-flatlaf.jar: rars.jar
	./build-jar-flatlaf.sh

clean:
	rm -f rars.jar rars-flatlaf.jar

