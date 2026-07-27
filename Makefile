TAG=mock-saml-local

.PHONY: build
build:
	podman build -t $(TAG) .

.PHONY: start1
start1:
	@if ! podman image ls --filter 'reference=localhost/$(TAG)' | grep -q "localhost/$(TAG)"; then \
	echo 'Image $(TAG) not found. Run `make build`'; \
	exit 1; \
	fi
	@if lsof -P -i -n | grep -i listen | grep :4000; then \
	echo 'Port 4000 is being used. Aborting'; \
	exit 1; \
	fi
	podman run \
	-p 4000:4000 \
	-e APP_URL="http://localhost:4000" \
	-e ENTITY_ID="https://saml.example.com/entityid" \
	-e PUBLIC_KEY="$(PUBLIC_KEY)" \
	-e PRIVATE_KEY="$(PRIVATE_KEY)" \
	-d $(TAG)

.PHONY: start2
start2:
	@if ! podman image ls --filter 'reference=localhost/$(TAG)' | grep -q "localhost/$(TAG)"; then \
	echo 'Image $(TAG) not found. Run `make build`'; \
	exit 1; \
	fi
	@if lsof -P -i -n | grep -i listen | grep :4001; then \
	echo 'Port 4001 is being used. Aborting'; \
	exit 1; \
	fi
	podman run \
	-p 4001:4000 \
	-e IDP_TITLE="Second IdP" \
	-e APP_URL="http://localhost:4001" \
	-e ENTITY_ID="https://saml-2.example.com/entityid" \
	-e PUBLIC_KEY="$(PUBLIC_KEY)" \
	-e PRIVATE_KEY="$(PRIVATE_KEY)" \
	-d $(TAG)
