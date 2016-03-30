CP         = .
JAVA       = java
JAVAC      = javac
JAVACFLAGS = -cp $(CP)
JFLEX      = /opt/jflex/jflex-1.6.1/lib/jflex-1.6.1.jar

no_targer:
	@ echo 'Especifique um target para executar'

run_file: build/KalkLexer.class
	@ java -cp build Main $(FILE)

build/KalkLexer.class: KalkLexer.java build
	@ $(JAVAC) $(JAVACFLAGS) Main.java KalkLexer.java
	@ mv *.class build/

build:
	@ mkdir build

KalkLexer.java: kalk.flex
	$(JAVA) -jar $(JFLEX) kalk.flex

clean:
	rm -f .byebug_history
	rm -rf build
	rm -rf *~
	rm -rf KalkLexer.java
	rm -rf grader/out

