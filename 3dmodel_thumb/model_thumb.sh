#!/bin/bash

#exec 2> /tmp/nc-flow-trace$$.log
#set -x

# ----- Create thumnails for 3mf, amf, obj, step, stl, x3d models" -----

relative_path="$1"

# ------------------------- Parameters ---------------------------------

cloud_data_path="/var/www/cloud_data"
occ_path="/var/www/cloud/occ"

minirender_path="/home/demonlibra/bot/minirender" # https://github.com/aslze/minirender
prusaslicer_path="/home/demonlibra/bot/prusaslicer/bin/prusa-slicer" # https://github.com/prusa3d/PrusaSlicer

max_size=10000000 # Create thumbnail for file size less than
thumb_resolution=800 # Size image
tilt=30 # rotation angle around X axis in degrees
yaw=20 # rotation angle around Z (vertical axis) in degrees

# ----------------------------------------------------------------------

if [[ "${relative_path:0:1}" == "/" ]]
  then full_path="${relative_path}"
  else full_path="${cloud_data_path}/${relative_path}"
fi

ext="${relative_path##*.}"

if [[ "${ext,,}" == "stl" ]] || [[ "${ext,,}" == "obj" ]] || [[ "${ext,,}" == "x3d" ]]
  then full_path_mesh="${full_path}"
  else full_path_mesh="${full_path%.*}.stl"
fi

full_path_png="${full_path%.*}.png"
relative_path_png="${full_path_png/${cloud_data_path}\//}"

# --------------------- Create or update file ----------------------

# File exist, not too big and thumb not exist
if [[ -f "$full_path" ]] && (( `stat -c '%s' "$full_path"` < $max_size )) && [[ ! -f "${full_path_png}" ]]
  then

    if [[ "${ext,,}" == "step" ]] || [[ "${ext,,}" == "stp" ]] || [[ "${ext,,}" == "amf" ]] || [[ "${ext,,}" == "3mf" ]]
      then
        if [[ ! -f "${full_path_mesh}" ]]
          then
            "${prusaslicer_path}" --export-stl "${full_path}"
            flag_del_stl=True
        fi
    fi

    "${minirender_path}" -o -- -tilt $tilt -yaw $yaw -w $thumb_resolution -h $thumb_resolution "${full_path_mesh}" | convert - "${full_path_png}"
    php --define apc.enable_cli=1 "${occ_path}" files:scan --no-ansi --shallow --path="$relative_path_png"

    # Delete temporary STL file
    if [ $flag_del_stl ]
      then rm -f "${full_path_mesh}"
    fi
fi
