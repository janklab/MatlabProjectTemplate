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
#   make doc-src - Build derived Markdown files in docs/
#   make clean - Remove derived files

PROGRAM=MyCoolProject
VERSION=$(shell cat VERSION)
DIST="dist/${PROGRAM}-${VERSION}"
DISTFILES=build/Mcode doc lib examples README.md LICENSE CHANGES.txt

.PHONY: test
test:
	./dev-kit/launchtests_mypackage

.PHONY: build
build:
	./dev-kit/build_mypackage

# Build the programmatically-generated parts of the _source_ files for the doco
.PHONY: docs
docs:
	rm -rf docs/examples
	cp -R examples docs

# Build the actual output documents
.PHONY: doc
doc: docs
	cd docs && ./make_doc

.PHONY: m-doc
m-doc: doc
	rm -rf build/M-doc
	mkdir -p build/M-doc
	cp -R doc/* build/M-doc
	rm -f build/M-doc/feed.xml

.PHONY: toolbox
toolbox: m-doc
	bash ./dev-kit/package_mypackage_toolbox

.PHONY: dist
dist: build m-doc
	rm -rf dist/*
	mkdir -p ${DIST}
	cp -R $(DISTFILES) $(DIST)
	cd dist; tar czf "${PROGRAM}-${VERSION}.tgz" --exclude='*.DS_Store' "${PROGRAM}-${VERSION}"
	cd dist; zip -rq "${PROGRAM}-${VERSION}.zip" "${PROGRAM}-${VERSION}" -x '*.DS_Store'

.PHONY: java
java:
	cd src/java/myproject-java; mvn package
	mkdir -p lib/java/myproject-java
	cp src/java/myproject-java/target/*.jar lib/java/myproject-java

.PHONY: clean
clean:
	rm -rf dist/* build docs/site docs/_site M-doc test-output

# Run this _after_ initialization if you want to throw away some nonessential
# features to make your repo layout simpler.
.PHONY: simplify
simplify:
	rm -rf .circleci .travis.yml azure-pipelines.yml src lib/java/MyCoolProject-java

# start-template-internal

# These targets is for MatlabProjectTemplate's internal use. Don't call them yourself.
# You can and should just delete this section after your project is initialized.
# (I can't do that for you because I actually need these targets *after* project
# initialization for work on MatlabProjectTemplate.)

.PHONY: rollback-init
rollback-init:
	git reset --hard
	rm -rf M-doc Mcode/+mycoolpackage docs/* doc/* \
	    src/java/MyCoolProject-java \
			dev-kit/*mycoolpackage* dev-kit/*MyCoolProject* MyCoolProject.mltbx MyCoolProject.prj.in \
			mycoolpackage*
	git reset --hard

# end-template-internal
