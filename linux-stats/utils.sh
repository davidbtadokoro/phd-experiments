#!/usr/bin/env bash

function print_help()
{
    printf '%s\n' 'USAGE:' \
        '  ./generate_data.sh <path-to-linux-mainline> <from-version> <to-version>'
}

function prepare_mainline()
{
    git -C "$mainline" switch --quiet master || return 1
    git -C "$mainline" fetch --quiet || return 1
    git -C "$mainline" pull --quiet || return 1
}

function version_exists()
{
    current_version="$1"

    git -C "$mainline" show-ref --tags --quiet "$current_version" || {
        printf 'Version %s does not exists' "$current_version"
        return 1
    }
}

function checkout_mainline_to()
{
    ref="$1"

    git -C "$mainline" checkout --quiet "$ref" || return 1
}

function find_last_minor_version()
{
    major_version="$1"

    git -C "$mainline" tag --list "v${major_version}.*" | grep -v '\-rc' | sort -V | tail -n1
}

function get_previous_version()
{
    local current_version="$1"
    local major_version=''
    local prev_major_version=''
    local minor_version=''
    local prev_minor_version=''

    # Calculate major versions
    major_version="${current_version#v}"
    major_version="${major_version%%.*}"
    prev_major_version=$((major_version - 1))

    # Calculate minor versions
    minor_version="${current_version#*.}"
    prev_minor_version=$((minor_version - 1))

    if version_exists "v${major_version}.${prev_minor_version}" > /dev/null; then
        printf 'v%s.%s' "$major_version" "$prev_minor_version"
        return 0
    fi
    
    last_minor_of_prev_major=$(find_last_minor_version "$prev_major_version")
    if [[ -n "$last_minor_of_prev_major" ]]; then
        printf '%s' "$last_minor_of_prev_major"
        return 0
    fi

    return 1
}

function get_next_version()
{
    local current_version="$1"
    local major_version=''
    local next_major_version=''
    local minor_version=''
    local next_minor_version=''

    # Calculate major versions
    major_version="${current_version#v}"
    major_version="${major_version%%.*}"
    next_major_version=$((major_version + 1))

    # Calculate minor versions
    minor_version="${current_version#*.}"
    next_minor_version=$((minor_version + 1))

    if version_exists "v${major_version}.${next_minor_version}" > /dev/null; then
        printf 'v%s.%s' "$major_version" "$next_minor_version"
        return 0
    elif version_exists "v${next_major_version}.0" > /dev/null; then
        printf 'v%s.0' "$next_major_version"
        return 0
    fi

    return 1
}

function count_physical_loc()
{
    cloc "$mainline" --csv | awk -F, 'END{print $NF}'
}

function count_maintainers()
{
    awk '/^M:|^R:/{print $2}' "${mainline}/MAINTAINERS" | sort -u | wc -l
}

function count_commits()
{
    from="$1"
    to="$2"

    git -C "$mainline" rev-list --count "$from".."$to"
}
