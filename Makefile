-include .env

MOLECULE_TEST ?= uv run molecule test

.PHONY : setup
setup :
	@(uv sync)

.PHONY : test
test :
	@(${MOLECULE_TEST})

.PHONY : test/ubuntu-2604
test/ubuntu-2604 :
	@(MOLECULE_DISTRO=ubuntu2604 ${MOLECULE_TEST})

.PHONY : test/ubuntu-2404
test/ubuntu-2404 :
	@(MOLECULE_DISTRO=ubuntu2404 ${MOLECULE_TEST})

.PHONY : test/ubuntu-2204
test/ubuntu-2204 :
	@(MOLECULE_DISTRO=ubuntu2204 ${MOLECULE_TEST})

.PHONY : test/debian-13
test/debian-13 :
	@(MOLECULE_DISTRO=debian11 ${MOLECULE_TEST})

.PHONY : test/debian-12
test/debian-12 :
	@(MOLECULE_DISTRO=debian12 ${MOLECULE_TEST})

.PHONY : test/debian-11
test/debian-11 :
	@(MOLECULE_DISTRO=debian11 ${MOLECULE_TEST})

.PHONY : test/rocky-9
test/rocky-9 :
	@(MOLECULE_DISTRO=rockylinux9 ${MOLECULE_TEST})

.PHONY : test/amazonlinux-2023
test/amazonlinux-2023 :
	@(MOLECULE_DISTRO=amazonlinux2023 ${MOLECULE_TEST})

.PHONY : test/all
test/all : test/ubuntu-2604
test/all : test/ubuntu-2404
test/all : test/ubuntu-2204
test/all : test/debian-13
test/all : test/debian-12
test/all : test/debian-11
test/all : test/rocky-9
test/all : test/amazonlinux-2023

.PHONY : lint
lint :
	@(uv run yamllint .)
