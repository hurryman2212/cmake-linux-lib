ifdef VERBOSE
NINJAFLAGS := -v
endif

.PHONY: all %
all:
	@ninja $(NINJAFLAGS)
%:
	@ninja $@ $(NINJAFLAGS)
