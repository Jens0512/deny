.ONESHELL:

-include Makefile.local

BIN     ?= bin/deny
SPEC    ?= bin/spec
FIND    ?= find
CRYSTAL ?= crystal
MAKE    += --no-print-directory

ifeq ($(dir $(BIN)),$(BIN))
override BIN := $(BIN)no
endif

INSTALL_LOCATION ?= $(BIN)

SOURCE_FILES := $(shell $(FIND) src  -type f -name '*.cr')
SPEC_FILES   := $(shell $(FIND) spec -type f -name '*.cr')
ALL_FILES    := $(SOURCE_FILES) $(SPEC_FILES)

CLI_TARGET  := src/cli.cr
SPEC_TARGET := spec/deny_spec.cr

time     :=
stats    :=
release  :=
progress :=

FLAGS += $(if $(time), -t) $(if $(progress), -p) $(if $(stats), -s)
FLAGS += $(if $(release), --release --no-debug)

all: build

build: $(BIN)

install:
	$(MAKE) build BIN=$(INSTALL_LOCATION) release=1

$(BIN): $(SOURCE_FILES)	
	$(build) $(CLI_TARGET)

define build := 
mkdir -p $(@D)
$(strip $(CRYSTAL) build $(FLAGS) -o $@)
endef

spec: $(SPEC)
	$(SPEC)

$(SPEC): $(ALL_FILES)
	$(build) $(SPEC_TARGET)
