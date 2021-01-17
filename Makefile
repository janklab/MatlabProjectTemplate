# This Makefile lets you:
#   - Build the project documentation ("make doc")
#   - Run tests ("make test")
#   - Package the project for distribution ("make dist")
#   
# The test run only works on Linux

# TODO: Should make dist have a dependency on make doc?

PROGRAM=myproject
VERSION=$(shell cat VERSION)
DIST=dist/${PROGRAM}-${VERSION}
FILES=README.md LICENSE Mcode doc lib tests examples

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
	cp -R $(FILES) $(DIST)
	cd dist; tar czf ${PROGRAM}-${VERSION}.tgz --exclude='*.DS_Store' ${PROGRAM}-${VERSION}
	cd dist; zip -rq ${PROGRAM}-${VERSION}.zip ${PROGRAM}-${VERSION} -x '*.DS_Store'

.PHONY: clean
clean:
	rm -rf dist/* doc-src/site doc-src/_site M-doc
