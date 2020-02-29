### MAKE_TARGETS ###############################################################

# Install and test the chart
.PHONY: all
all: lint

# Install and test the chart and then clean
.PHONY: chart
chart: all
	$(MAKE) clean

# Lint the chart
.PHONY: lint
lint: helm-lint

# Delete the Kubernetes cluster and working files
.PHONY: clean
clean:
	@true

### HELM_CHART_MK ##############################################################

PROJECT_DIR		?= $(CURDIR)/../..
HELM_CHART_REPO_DIR	?= $(PROJECT_DIR)/../helm-charts
MK_DIR			?= $(PROJECT_DIR)/../Mk
include $(MK_DIR)/helm.chart.mk

################################################################################
