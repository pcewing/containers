#!/usr/bin/env bash

function yell () { >&2 echo "$*";  }
function die () { yell "$*"; exit 1; }
function try () { "$@" || die "Command failed: $*"; }

REPO_DIR="$( dirname "$( realpath "$0" )" )"

ARG_UID="$(id -u)"
ARG_GID="$(id -g)"
ARG_USERNAME="$(id -un)"

function usage() {
    yell "Usage: make.sh <command>"
    yell "Commands:"
    yell "    focal     : Build the Ubuntu 20.04 (Focal) container image"
    yell "    jammy     : Build the Ubuntu 22.04 (Jammy) container image"
    yell "    centos    : Build the CentOS 7 container image"
    yell "    alpine    : Build the Alpine container image"
    yell "    all       : Build all of the container images"
    yell "    list      : List all of the container images"
}

function build_container_image() {
    local image name
    image="$1"
    name="$2"

    echo "Building $name container image"
    try docker build \
        --build-arg "username=$ARG_USERNAME" \
        --build-arg "uid=$ARG_UID" \
        --build-arg "gid=$ARG_GID" \
        --tag "$name" \
        --file "images/$image.Dockerfile" \
        .
}

function cmd_focal() {
    build_container_image "ubuntu-20.04" "$ARG_USERNAME-ubuntu-20.04"
}

function cmd_jammy() {
    build_container_image "ubuntu-22.04" "$ARG_USERNAME-ubuntu-22.04"
}

function cmd_centos() {
    build_container_image "centos-7" "$ARG_USERNAME-centos-7"
}

function cmd_alpine() {
    build_container_image "alpine" "$ARG_USERNAME-alpine"
}

function cmd_all() {
    cmd_focal
    cmd_jammy
    cmd_centos
    cmd_alpine
}

function cmd_list() {
    echo "Container images:"
    docker image ls | grep "$ARG_USERNAME-"
}

function main() {
    local func cmd

    cmd="$1"

    func="usage"
    case "$cmd" in
        "focal")    func="cmd_focal"    ;;
        "jammy")    func="cmd_jammy"    ;;
        "centos")   func="cmd_centos"   ;;
        "alpine")   func="cmd_alpine"   ;;
        "all")      func="cmd_all"      ;;
        "list")     func="cmd_list"     ;;
        *)          func="usage"        ;;
    esac

    try pushd "$REPO_DIR" &>/dev/null
    $func
    try popd &>/dev/null
}

main "$1"
