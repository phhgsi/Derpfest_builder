#!/bin/bash

set -e

# Update repo tool
mkdir -p ~/.bin
curl https://storage.googleapis.com/git-repo-downloads/repo-2.42 > ~/.bin/repo
chmod +x ~/.bin/repo
export PATH=~/.bin:$PATH

# Set Crave to build using LineageOS 20 as base
repo init -u https://github.com/DerpFest-AOSP/manifest.git -b 14
crave set --projectID 36

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "rm -rf .repo/local_manifests && \

# Clone local_manifests repository
git clone https://github.com/phhgsi/local_manifest.git .repo/local_manifests -b main ;\

# Removals

# Sync the repositories
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \ 
rm -rf hardware/google/pixel/kernel_headers && \

# Set up build environment
source build/envsetup.sh && \

# Lunch configuration
lunch derp_oscar-eng ;\

# Start Build
croot ;\
m installclean; \
mka bacon ; \
echo "Date and time:" ; \

# Print out/build_date.txt
cat out/build_date.txt; \

# Print SHA256
sha256sum out/target/product/*/*.zip"

# Clean up
# rm -rf tissot/*

# Pull generated zip files
# crave pull out/target/product/*/*.zip 

# Pull generated img files
crave pull out/target/product/*/*.zip

# Upload zips to Telegram
# telegram-upload --to sdreleases tissot/*.zip

#Upload to Github Releases
#curl -sf https://raw.githubusercontent.com/Meghthedev/Releases/main/headless.sh | sh
