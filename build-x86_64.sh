#!/bin/bash

org.flatpak.Builder build-dir \
	--arch=x86_64 \
	--force-clean \
	--install-deps-from=flathub \
	--repo=repo \
	com.jetbrains.Rider.yaml
