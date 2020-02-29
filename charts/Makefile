SUBDIRS		?= common examples
TARGET		?= chart

# Make all subdirs
.PHONY: all
all: $(SUBDIRS)

# Make the subdirs
.PHONY: $(SUBDIRS)
$(SUBDIRS):
	@cd $@; $(MAKE) $(TARGET)

# Clean all
.PHONY: clean
clean:
	@$(MAKE) all TARGET=clean
