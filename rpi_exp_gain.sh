#!/bin/bash

FRAMES=24
GAINS=(1 4 8)
EXPOSURES=(358000 11760000)

for GAIN in "${GAINS[@]}"; do
    for EXPOSURE in "${EXPOSURES[@]}"; do
        # Print current settings
        printf "\nSETTINGS: [GAIN:%02d, EXPOSURE:%08dμs]\n" "$GAIN" "$EXPOSURE"

        # Define and create output directories
        OUTDIR=$(printf "imgs/gain-%02d_exp-%08d" "$GAIN" "$EXPOSURE")
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

        done
        printf "\n"
    done
done
