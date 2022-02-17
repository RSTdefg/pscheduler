#
# Makefile for pScheduler top-level directory
#

default: build


BUILD_LOG=unibuild-log

ifdef START
START_OPTS := --start $(START)
endif

# The shell command below does the equivalent of BASH's pipefail
# within the confines of POSIX.
# Source: https://unix.stackexchange.com/a/70675/15184
build:
	rm -rf $(BUILD_LOG)
	((( \
	(unibuild build $(START_OPTS); echo $$? >&3) \
	| tee $(BUILD_LOG) >&4) 3>&1) \
	| (read XS; exit $$XS) \
	) 4>&1
TO_CLEAN += $(BUILD_LOG)


uninstall:
	unibuild make --reverse $@

fresh: uninstall build

clean:
	unibuild make clean
	unibuild clean
	$(MAKE) -C docs $@
	rm -rf $(TO_CLEAN)
	find . -name '*~' | xargs rm -f
