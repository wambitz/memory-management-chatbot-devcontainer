.PHONY: all
all: format test build

.PHONY: format
format:
	clang-format src/*.cpp src/*.h -i

.PHONY: tidy
tidy:
	clang-tidy src/*.cpp -- -std=c++17 -I/usr/include/wx-3.0 -I/usr/lib/x86_64-linux-gnu/wx/include/gtk3-unicode-3.0

.PHONY: tidy-fix
tidy-fix:
	clang-tidy src/*.cpp -fix -- -std=c++17 -I/usr/include/wx-3.0 -I/usr/lib/x86_64-linux-gnu/wx/include/gtk3-unicode-3.0

.PHONY: build
build:
	mkdir -p build
	cd build && \
	cmake .. && \
	make

.PHONY: debug
debug:
	mkdir -p build
	cd build && \
	cmake -DCMAKE_BUILD_TYPE=debug .. && \
	make

.PHONY: clean
clean:
	rm -rf build
