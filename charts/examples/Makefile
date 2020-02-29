### MAKE_TARGETS ###############################################################

# Install and test the chart
.PHONY: all
all: lint upgrade status logs test

# Install and test the chart and then clean
.PHONY: chart
chart: all
	$(MAKE) clean

# Create symbolic link to common chart
charts/common:
	@set -x; \
	mkdir -p charts; \
	cd charts; \
	ln -s ../../common common

# Lint the chart
.PHONY: lint
lint: charts/common helm-lint

# Create a Kubernetes cluster
.PHONY: cluster
cluster: charts/common helm-cluster

# Install the chart
.PHONY: install
install: cluster helm-install

# Upgrade the chart
.PHONY: upgrade
upgrade: cluster helm-upgrade

# Show status of chart resources
.PHONY: status
status: install helm-status

# Show the chart logs
.PHONY: logs
logs: install helm-logs

# Tail the chart logs
.PHONY: tail
tail: install helm-tail

# Run the tests
.PHONY: test
test: install helm-test

# Package the chart
.PHONY: package
package: helm-package

# Publish the chart
# TODO: https://github.com/helm/chart-releaser
# TODO: https://github.com/helm/chart-releaser-action
# TODO: https://github.com/unguiculus/gh-pages-helm-chart-repo-example
.PHONY: publish
publish: package helm-publish

# Uninstall the chart
.PHONY: uninstall
uninstall: helm-uninstall

# Delete the Kubernetes cluster and working files
.PHONY: clean
clean: helm-clean
	@set -x; \
	rm -rf charts Chart.lock

### HELM_CHART_MK ##############################################################

PROJECT_DIR		?= $(CURDIR)/../..
HELM_CHART_REPO_DIR	?= $(PROJECT_DIR)/../helm-charts
MK_DIR			?= $(PROJECT_DIR)/../Mk
include $(MK_DIR)/helm.chart.mk

################################################################################
