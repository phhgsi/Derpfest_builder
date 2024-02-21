#!/bin/bash

set -e

# Set Crave to build using LineageOS 20 as base
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
crave set --projectID 36

# Run inside foss.crave.io devspace, in the project folder
# Remove existing local_manifests
crave run --no-patch -- "rm -rf .repo/local_manifests && \

# Clone local_manifests repository
git clone https://github.com/lion-development/local_manifests.git .repo/local_manifests -b lineage-20 ;\

# Removals
# rm -rf system/libhidl prebuilts/clang/host/linux-x86 prebuilt/*/webview.apk platform/external/python/pyfakefs platform/external/python/bumble external/chromium-webview/prebuilt/x86_64 platform/external/opencensus-java RisingOS_gsi patches device/phh/treble && \

# Sync the repositories
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \ 

# Set up build environment
source build/envsetup.sh && \

# Lunch configuration
lunch lineage_X6816-userdebug ;\

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
