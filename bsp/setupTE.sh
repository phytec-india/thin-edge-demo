#!/bin/bash

set -e

YOCTO_ROOT=$(pwd)

PATCH1="patches/0001-Add-Te-PD-25.1.0-and-custom-headless-image-modificat.patch"
PATCH2="patches/0002-meta-tpm-Fix-tpm2-tss-engine-build-issue.patch"

META_PHYTEC="sources/meta-phytec"
META_SECURITY="sources/meta-security"

echo "=============================================="
echo " Applying Layer Patches for Te-PD-25.1.0"
echo "=============================================="

# ---------- PATCH 1 (meta-phytec) ----------
echo ""
echo "Checking Patch 0001 (meta-phytec)..."

cd "$YOCTO_ROOT/$META_PHYTEC"

if git apply --reverse --check "$YOCTO_ROOT/$PATCH1" 2>/dev/null; then
    echo "Patch 0001 already applied — skipping."
else
    git apply --whitespace=fix "$YOCTO_ROOT/$PATCH1"
    echo "Patch 0001 applied successfully."
fi


# ---------- PATCH 2 (meta-security) ----------
echo ""
echo "Checking Patch 0002 (meta-security)..."

cd "$YOCTO_ROOT/$META_SECURITY"

if git apply --reverse --check "$YOCTO_ROOT/$PATCH2" 2>/dev/null; then
    echo "Patch 0002 already applied — skipping."
else
    git apply --whitespace=fix "$YOCTO_ROOT/$PATCH2"
    echo "Patch 0002 applied successfully."
fi


echo ""
echo "=============================================="
echo " All required patches processed successfully."
echo "=============================================="
echo ""
echo "Now run:"
echo "source poky/oe-init-build-env build"
