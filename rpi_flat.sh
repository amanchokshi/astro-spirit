#!/bin/bash

# Flat frames for the raspberry pi camera v2

# Left balanced histogram exposure, with uniform white exposure, as best as 
# possible. I placed a thin tissue on my phone and put the camera on it

GAIN=1
FRAMES=24
EXPOSURE=100000

# FLAT
# Define and create output directories
OUTDIR=$(printf "flat/gain-%02d_exp-%08d" "$GAIN" "$EXPOSURE")
mkdir -p "${OUTDIR}/png" "${OUTDIR}/dng"

# Loop through frames
for ((FRAME=0; FRAME<=FRAMES; FRAME++)); do
    # Print frame number with overwriting
    printf "FRAME: [%03d]\n" $FRAME

    # Capture image
    rpicam-still --immediate --raw --nopreview \
        --awbgains 2,1.4 \
        --gain "${GAIN}" \
        --shutter "${EXPOSURE}" \
        --output "${OUTDIR}/${FRAME}.png"

    # Check if the file was created successfully
    if [[ -f "${OUTDIR}/${FRAME}.png" ]]; then
        mv "${OUTDIR}/${FRAME}.png" "${OUTDIR}/png/"
    fi

    if [[ -f "${OUTDIR}/${FRAME}.dng" ]]; then
        mv "${OUTDIR}/${FRAME}.dng" "${OUTDIR}/dng/"
    fi

    sleep 0.1
    printf "\n"

done
