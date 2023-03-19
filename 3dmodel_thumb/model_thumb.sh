#!/bin/bash

#exec 2> /tmp/nc-flow-trace$$.log
#set -x

echo "Run workflow script - Create thumnails for STEP and STL models"

path="$1"

# --------------------- Parameters ---------------------------------

cloud_data_path="/var/www/cloud_data"
cloud_path="/var/www/cloud"

minirender_path="/home/demonlibra/bot/minirender"
ps_path="/home/demonlibra/bot/prusaslicer/bin/prusa-slicer"

max_size=10000000
thumb_resolution=800

# ------------------------------------------------------------------

if [[ "${path:0:1}" = "/" ]]
  then full_path="$1"
  else full_path="${cloud_data_path}/$1"
fi

ext="${full_path##*.}"

if [[ "${ext,,}" == "stl" ]]
  then full_path_stl="${full_path}"
  else full_path_stl="${full_path%.*}.stl"
fi

full_path_png="${full_path%.*}.png"
relative_path_png="${full_path_png/${cloud_data_path}\//}"

# --------------------- Create or update file ----------------------

# File exist, not too big and thumb not exist
if [[ -f "$full_path" ]] && (( `stat -c '%s' "$full_path"` < $max_size )) && [[ ! -f "${full_path_png}" ]]
  then

    if [[ "${ext,,}" == "step" ]] || [[ "${ext,,}" == "stp" ]]
      then
        if [[ ! -f "${full_path_stl}" ]]
          then
            "$ps_path" --export-stl "${full_path}"
            flag_del_stl=True
        fi
    fi

    "${minirender_path}" -o -- -tilt 30 -yaw 20 -w $thumb_resolution -h $thumb_resolution "${full_path_stl}" | convert - "${full_path_png}"
    php --define apc.enable_cli=1 "${cloud_path}/occ" files:scan --no-ansi --shallow --path="$relative_path_png"

    # Delete temporary STL file
    if [ $flag_del_stl ]
      then rm -f "${full_path_stl}"
    fi
fi
