#!/bin/bash

org.flatpak.Builder build-dir \
	--arch=aarch64 \
	--force-clean \
	--install-deps-from=flathub \
	--repo=repo \
	com.jetbrains.Rider.yaml
