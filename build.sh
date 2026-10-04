#!/bin/bash

flatpak-builder build-dir \
	--force-clean \
	--install \
	--install-deps-from=flathub \
	--repo=repo \
	--user \
	com.jetbrains.Rider.yaml
