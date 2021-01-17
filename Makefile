# This Makefile lets you build the project and its documentation, run tests,
# package it for distribution, and so on.
#
# Targets provided:
#
#   make doc - Build the project documentation into doc/
#   make test - Run the project Matlab unit tests
#   make toolbox - Build the project as a Matlab Toolbox .mltbx file
#   make dist - Build the project distribution zip files
#   make java - Build your custom Java code in src/ and install it into lib/

# TODO: Should make dist have a dependency on make doc?

PROGRAM=myproject
VERSION=$(shell cat VERSION)
DIST=dist/${PROGRAM}-${VERSION}
DISTFILES=Mcode doc lib tests examples README.md LICENSE CHANGES.txt

.PHONY: test
test:
	./dev-kit/launchtests

.PHONY: doc
doc:
	cd doc-src && ./make_doc
.PHONY: m-doc
m-doc: doc
	rm -rf M-doc
	mkdir M-doc
	cp -R doc/* M-doc
	rm -f M-doc/feed.xml

.PHONY: toolbox
toolbox:
	bash package_toolbox.sh

.PHONY: dist
dist: m-doc
	rm -rf dist/*
	mkdir -p ${DIST}
	cp -R $(DISTFILES) $(DIST)
	cd dist; tar czf ${PROGRAM}-${VERSION}.tgz --exclude='*.DS_Store' ${PROGRAM}-${VERSION}
	cd dist; zip -rq ${PROGRAM}-${VERSION}.zip ${PROGRAM}-${VERSION} -x '*.DS_Store'

.PHONY: java
java:
	cd src/java/myproject-java; mvn package
	cp src/java/myproject-java/target/*.jar lib/java/myproject-java

.PHONY: clean
clean:
	rm -rf dist/* doc-src/site doc-src/_site M-doc

# This is for MatlabProjectTemplate's internal use. Don't call it yourself.
.PHONY: rollback-init
rollback-init:
	rm -rf M-doc doc-src Mcode/+mycoolpackage doc/* src/java/MyProject-java/src/main/java/com/example/mycoolpackage