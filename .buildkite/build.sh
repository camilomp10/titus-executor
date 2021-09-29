#!/usr/bin/env bash
set -uex -o pipefail

log() {
    echo -e "[$(date -u +"%Y-%m-%dT%H:%M:%SZ")] $1" >&2
}

apt-get -y install shellcheck

GO_VERSION=1.16.8
GO_INSTALL_DIR=${HOME}/go_installs/${GO_VERSION}
if [[ ! -d ${GO_INSTALL_DIR}/go ]]; then
    mkdir -p ${GO_INSTALL_DIR}
    curl -Sfl https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz |tar -xz -C ${GO_INSTALL_DIR}
fi
export GOPATH="${HOME}/go"
export PATH="${GO_INSTALL_DIR}/go/bin:${GOPATH}/bin:${PATH}"
export TEST_FLAGS="-v -parallel 1"

log "Building executor"

make clean
make --output-sync -j16 builder all 2>&1 | tee build.log


