#!/bin/bash

# Version 2012-02-07

# Compilation stuff
function compile {
  # Nice path where the CSS belong
  dir=$(readlink -f $(dirname "${cssroot}/${1/#$lessroot}"))
  echo "$1: changes detected."

  # The CSS dir does not exist and must be created
  if [[ -n $dir && ! -d $dir ]]; then
    echo "${dir} does not exist. Creating..."
    mkdir -p $dir
  fi

  # Compilation and write
  lessc -x "$1" > "${dir}/$(basename ${1/%.less/.css})"
}

# Help stuff
case $1 in
  "--help")
    echo "Usage: ${0} [LESS files root] [CSS files root]\n"
    echo "Arguments:"
    echo "    If not given, LESS files root will be current directory."
    echo "    If not given, CSS files root will either be \"../css\" (LESS files root not given) or \"./css\" (LESS files root given)."
    echo "    If CSS files root does not exist, an attempt to create it will be made.\n"
    echo "Additions to pure LESS:"
    echo "  Files with first line being \"//-css\" will NOT generate the appropriate CSS file (good for imported files)."
    echo "  Files containing \"//+otherfile(.less)\" lines will cause these to be regenerated (good for rebuilding the import tree).\n"
    exit 42
    ;;
  "--version")
    echo "${0} version 2012-02-07"
    ;;
esac


# Global vars: script arguments
lessroot=$1
cssroot=$2

# Ajustments on $lessroot var
if [[ -z $lessroot ]]; then
  lessroot=$(pwd)
  echo "No LESS directory specified, using ${lessroot} as LESS files root directory."
elif [[ ! -d $lessroot ]]; then
  echo "Aborting: ${lessroot} is not a directory."
  exit 1
else
  echo "Watching ${lessroot} for LESS files..."
fi

# Ajustments on $cssroot var
if [[ -z $cssroot ]]; then
  # Assuming $lessroot was not given
  if [[ -z $1 ]]; then
    cssroot=$(readlink -f "$lessroot/../css")

  # else...
  else
    cssroot=$(readlink -f ./css)
  fi

  echo "No CSS directory specified, using ${cssroot} as CSS files root directory."
else
  echo "Watching ${cssroot} for CSS files..."
fi

# CSS dir does not exist; create it or die
if [[ ! -e $cssroot ]]; then
  echo "${cssroot} does not exist. Creating..."
  mkdir -p $cssroot
elif [[ ! -d $cssroot ]]; then
  echo "Aborting: ${cssroot} already exists and is not a directory."
  exit 2
fi

# Wait for modifications in folder $lessroot
while read file; do
  # Relative path from current directory, and basename (without .less extension)
  file="${file/#$(pwd)}"
  striped=${file/%.less}

  # If filename does not end in ".less", drop it
  if [[ $striped = $file ]]; then
    continue
  fi

  # Search for imports, and process them
  while read import; do
    compile "$(dirname $file)/${import}.less"
  done < <(sed -n 's#^//+\(.\+\)\(\.less\)?$#\1#p' "$file")

  # Ignore the file itself if starts with //-css
  if [[ $(head -n1 $file) = "//-css" ]]; then
    continue
  fi

  # Kick that shit
  compile "$file"
done < <(inotifywait -rqm -e MODIFY -e MOVED_TO --format "%w%f" $lessroot)
