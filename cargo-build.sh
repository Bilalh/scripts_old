#!/bin/sh

REPO_URL="https://crates.io"
API_URL="$REPO_URL/api/v1"

die() {
    echo "$@" >&2
    exit 1
}

CRATE="$1"

DL_PATH="$(curl -s "$API_URL/crates/$CRATE/versions" | grep -E -o '"dl_path":"([^"]+)"' | head -n 1 | sed -e 's/"dl_path":"//' -e 's/"//')"

test -z "$DL_PATH" && die "Unable to find downloads for ${CRATE}!"

DL_URL="${REPO_URL}${DL_PATH}"

CRATE_VER="${DL_PATH#/api/v1/crates/$CRATE/}"
CRATE_VER="${CRATE_VER%/download}"

CRATE_DIR="${CRATE}-${CRATE_VER}"
CRATE_FILE="${CRATE_DIR}.crate"

mkdir -p "${CRATE_DIR}" || die "Error creating crate build directory!"
cd "${CRATE_DIR}"

echo "Found crate at $DL_URL, downloading..."

curl -Lo "${CRATE_FILE}" "${DL_URL}" || die "Error downloading crate file!"

tar xf "${CRATE_FILE}" && cd "${CRATE_DIR}" && \
cargo build --release && find ./target/release -maxdepth 1 -type f -perm -111 -exec cp {} .. \; && \
cd .. && rm -rf "${CRATE_DIR}" "${CRATE_FILE}"

echo "Built binaries are at ${CRATE_DIR}."
