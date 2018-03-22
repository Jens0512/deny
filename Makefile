.ONESHELL:

BIN     ?= bin/no
FIND    ?= /usr/bin/find
TARGET  ?= src/no.cr
CRYSTAL ?= crystal

INSTALL_LOCATION ?= $(BIN)

SOURCE_FILES := $(shell $(FIND) src -type f -name '*.cr')

time     :=
progress :=
stats    :=

ifeq ($(dir $(BIN)),$(BIN))
override BIN := $(BIN)no
endif

ifeq ($(dir $(INSTALL_LOCATION)),$(INSTALL_LOCATION))
override INSTALL_LOCATION := $(INSTALL_LOCATION)no
endif

# Just to indicate its presence
FLAGS += $(if $(time), -t) $(if $(progress), -p) $(if $(stats), -s)
MAKE  += --no-print-directory

build: $(BIN)

install: export FLAGS := --release --no-debug
install: export BIN   := $(INSTALL_LOCATION)
install:
	$(MAKE) build

$(BIN): $(SOURCE_FILES)	
	mkdir -p $(dir $@)
	$(build) $(TARGET)

build = $(strip $(CRYSTAL) build $(FLAGS) -o $@)