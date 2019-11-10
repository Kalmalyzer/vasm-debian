
# Unix build script

include Config.mk

BUILD_RESULTS_DIR = build_results

default: build

.PHONY: clean download build install uninstall

clean:
	rm -rf vasm
	rm -f vasm.tar.gz

download:
	wget -O vasm.tar.gz $(VASM_URL)
	tar -xvf vasm.tar.gz
	rm vasm.tar.gz

build:
	(cd vasm && make CPU=m68k SYNTAX=mot && chmod ugo+rx vasmm68k_mot)
	(cd vasm && make CPU=m68k SYNTAX=std && chmod ugo+rx vasmm68k_std)

package:
	mkdir -p $(BUILD_RESULTS_DIR)
	cp ../vasmm68k_*_amd64.deb $(BUILD_RESULTS_DIR)
	(cd $(BUILD_RESULTS_DIR) && tar -cvf linux-deb-package.tgz vasmm68k_*_amd64.deb)
	rm $(BUILD_RESULTS_DIR)/vasmm68k_*_amd64.deb

install:
	mkdir -p $(DESTDIR)/usr/bin
	cp vasm/vasmm68k_mot $(DESTDIR)/usr/bin/
	chmod ugo+rx $(DESTDIR)/usr/bin/vasmm68k_mot

	cp vasm/vasmm68k_std $(DESTDIR)/usr/bin/
	chmod ugo+rx $(DESTDIR)/usr/bin/vasmm68k_std

uninstall:
	rm -f /usr/bin/vasmm68k_mot
	rm -f /usr/bin/vasmm68k_std
