#!/bin/bash

org.flatpak.Builder \
	build-x86_64 \
	--arch=x86_64 \
	--force-clean \
	--install-deps-from=flathub \
	--repo=repo \
	com.jetbrains.Rider.yaml
