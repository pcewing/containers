.PHONY: all
all:
	@./make.sh all

.PHONY: list
list:
	@./make.sh list

.PHONY: build-ubuntu-focal
build-ubuntu-focal:
	@./make.sh focal

.PHONY: build-ubuntu-jammy
build-ubuntu-jammy:
	@./make.sh jammy

.PHONY: build-centos
build-centos:
	@./make.sh centos

.PHONY: build-alpine
build-alpine:
	@./make.sh alpine
