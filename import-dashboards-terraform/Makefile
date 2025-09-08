IMAGE_NAME ?= import-tf-script
SIGNALFX_API_URL ?= https://app.us0.signalfx.com
RELATIVE_DIR_PATH ?= "generated-dashboards"


ifneq (${MAKEFILE_DIR_LOCATION},${WORKING_DIR})

%:
    $(MAKE) -C ${MAKEFILE_DIR_LOCATION} $@

.PHONY: %

else

.PHONY: tidy
tidy:
	go mod tidy

.PHONY: fmt
fmt:
	go fmt ./...

.PHONY: build
build:
	docker buildx build -t $(IMAGE_NAME) .

.PHONY: import-dashboard-group
import-dashboard-group: clean build
	@docker run --volume="$(shell pwd):/terraform-state" \
	-it $(IMAGE_NAME) --api-url $(SIGNALFX_API_URL) \
	--api-token=$(SIGNALFX_AUTH_TOKEN)  \
	--groups $(GROUP_IDS) \
	--dir /terraform-state/$(RELATIVE_DIR_PATH) \
	--add-var-file \
	--add-versions-file \
    --allow-chart-name-conflict

.PHONY: clean
clean:
	@echo "Cleaning up containers and image for $(IMAGE_NAME)"
	@docker ps -a -q --filter ancestor=$(IMAGE_NAME) | xargs -r docker rm -f 2>/dev/null || true
	@docker rmi $(IMAGE_NAME) -f 2>/dev/null || true
endif