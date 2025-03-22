#!/usr/bin/env bash
. 'utils.sh' --source-only

# variables
mainline=''
from_version=''
to_version=''

if [[ "$#" != 3 ]]; then
    print_help
fi

mainline="$1"
from_version="$2"
to_version="$3"

printf '* Preparing Linux mainline for data analysis\n'
output=$(prepare_mainline)
if [[ "$?" != 0 ]]; then
    printf 'Error in preparing the Linux mainline'
    exit 1
fi
version_exists "$from_version" || exit 1
version_exists "$from_version" || exit 1

set -e # from now on, exit on any error

mkdir --parents 'output'

printf '* Analyzing Linux mainline stats from version %s to version %s\n' "$from_version" "$to_version"

printf 'version,physical-loc,nr-maintainers,nr-commits\n' > 'output/data.csv'

current_version="$(get_previous_version "$current_version")"
while [[ "$current_version" != "$to_version" ]]; do
    previous_version="$current_version"
    current_version="$(get_next_version "$current_version")"
    printf '** Processing version %s\n' "$current_version"
    checkout_mainline_to "$current_version"
    printf '%s,%s,%s,%s\n' "$current_version" "$(count_physical_loc)" "$(count_maintainers)" "$(count_commits "$previous_version" "$current_version")" >> 'output/data.csv'
done

printf '* Data generation to `output/data.csv` successful!\n'

# Activate python venv in case it exists
if [[ -f '/linux-stats/venv/bin/activate' ]]; then
    source /linux-stats/venv/bin/activate
fi

printf '* Generating plots\n'
python3 plot.py

printf '* Plot generation to `output/{phys-loc,maintainers,commits}.pdf` successful!\n'
