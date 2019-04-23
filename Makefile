build:
	mkdir -p build
test: build
	mkdir -p build/test
test/varint: test varint/test/*.pony
	ponyc varint/test -o build/test --debug
test/execute: test/varint
	./build/test/test
clean:
	rm -rf build

.PHONY: clean test
