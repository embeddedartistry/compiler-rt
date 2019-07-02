# you can set this to 1 to see all commands that are being run
export VERBOSE := 0

ifeq ($(VERBOSE),1)
export Q :=
export VERBOSE := 1
else
export Q := @
export VERBOSE := 0
endif

BUILDRESULTS?=buildresults

all: compiler_rt

.PHONY: groundwork
groundwork:
	$(Q)if [ -d "$(BUILDRESULTS)" ]; then mkdir -p $(BUILDRESULTS); fi
	$(Q)if [ ! -e "$(BUILDRESULTS)/build.ninja" ]; then meson --buildtype plain $(BUILDRESULTS); fi

.PHONY: compiler_rt
compiler_rt: groundwork
	$(Q)cd $(BUILDRESULTS); ninja

.PHONY: list-targets
list-targets: groundwork
	$(Q) cd $(BUILDRESULTS); ninja -t targets

.PHONY: list-targets-all
list-targets-all: groundwork
	$(Q) cd $(BUILDRESULTS); ninja -t targets all

.PHONY: analyze
analyze: groundwork
	$(Q) cd $(BUILDRESULTS); ninja scan-build

.PHONY: clean
clean:
	$(Q)echo Cleaning build artifacts
	$(Q)if [ -d "$(BUILDRESULTS)" ]; then cd $(BUILDRESULTS); ninja -t clean; fi
	$(Q)if [ -d "buildresults-coverage" ]; then cd buildresults-coverage; ninja -t clean; fi

.PHONY: purify
purify:
	$(Q)echo Removing Build Output
	$(Q)rm -rf $(BUILDRESULTS)/

.PHONY: tidy
tidy: groundwork
	$(Q) cd $(BUILDRESULTS); ninja tidy

### Help Rule ###
.PHONY : help
help :
	@echo "usage: make [OPTIONS] <target>"
	@echo "  Options:"
	@echo "    > VERBOSE     Boolean. Default Off."
	@echo "    > BUILDRESULTS Directory for build results. Default buildresults."
	@echo "Targets:"
	@echo "  To list targets that ninja can compile:"
	@echo "    list-targets: list build targets for project"
	@echo "    list-targets-all: list all targets ninja knows about"
	@echo "  groundwork: runs meson and repares the BUILDRESULTS directory"
	@echo "  buildall: builds all targets that ninja knows about"
	@echo "  clean: cleans build artifacts"
	@echo "  purify: removes the BUILDRESULTS directory"
	@echo "  Static Analysis:"
	@echo "    analyze: runs clang static analysis"
	@echo "    tidy: runs clang-tidy linter"
