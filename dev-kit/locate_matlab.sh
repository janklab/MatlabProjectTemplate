# Knows how to locate Matlab and get it on the path.
#
# This is intended to be sourced by other scripts, not run as a command.

if which matlab &>/dev/null; then
  matlab=matlab
else
  os=$(uname)
  if [[ $os -eq "Darwin" ]]; then
      search_order="${PREFERRED_MATLAB_VERSIONS:-R2021a R2020b R2020a R2019b R2019a R2018b R2018a}"
      for rel in $search_order; do
        app_path="/Applications/MATLAB_${rel}.app"
        echo "Checking $app_path..."
        if [[ -e "$app_path" ]]; then
          matlab="$app_path/bin/matlab"
          break
        fi
      done
  else
    echo >&2 "Error: No matlab on path, and I don't know how to detect it on Linux."
    echo >&2 "Error: Please ensure Matlab is installed, and get it on your \$PATH."
    exit 1
  fi
fi

if [[ -z "$matlab" ]]; then
  echo >&2 "Error: matlab is not on the path and it could not be detected."
  exit 1
fi
