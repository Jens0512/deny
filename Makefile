.ONESHELL:

BIN     ?= bin/no
SPEC    ?= bin/spec
FIND    ?= /usr/bin/find
CRYSTAL ?= crystal
MAKE    += --no-print-directory

INSTALL_LOCATION ?= $(BIN)

SOURCE_FILES := $(shell $(FIND) src  -type f -name '*.cr')
SPEC_FILES   := $(shell $(FIND) spec -type f -name '*.cr')
ALL_FILES    := $(SOURCE_FILES) $(SPEC_FILES)

CLI_TARGET  = src/no.cr
SPEC_TARGET = spec/no_spec.cr

time     :=
progress :=
stats    :=
release  :=

ifeq ($(dir $(BIN)),$(BIN))
override BIN := $(BIN)no
endif

ifeq ($(dir $(INSTALL_LOCATION)),$(INSTALL_LOCATION))
override INSTALL_LOCATION := $(INSTALL_LOCATION)no
endif

FLAGS += $(if $(time), -t) $(if $(progress), -p) $(if $(stats), -s)
FLAGS += $(if $(release), --release --no-debug)

all: build

build: $(BIN)

install:
	$(MAKE) build BIN=$(INSTALL_LOCATION) release=1

$(BIN): $(SOURCE_FILES)	
	$(build) $(CLI_TARGET)

define build = 
mkdir -p $(dir $@) 
$(strip $(CRYSTAL) build $(FLAGS) -o $@)
endef

spec: $(SPEC)
	$(SPEC)

$(SPEC): $(ALL_FILES)
	$(build) $(SPEC_TARGET)
