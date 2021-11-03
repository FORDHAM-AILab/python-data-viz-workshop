#!/bin/bash

# get paths and venv status
SCRIPT=$(realpath "$0")
SLIDES_DIR=$(dirname "$SCRIPT")
REPO_DIR=$(dirname "$SLIDES_DIR")
ACTIVE_ENV=$(basename $CONDA_DEFAULT_ENV)


if [[ "$CONDA_DEFAULT_ENV" == "" ]]; then
    echo "Virtual environment is not enabled. Quitting...";
else
    if [[ "$CONDA_DEFAULT_ENV" != "data_viz_workshop" ]]; then
        echo "The data_viz_workshop conda env is not activated.";
    else
        # if nbmerge isn't installed, do so
        echo "Checking for nbmerge..."
        pip3 freeze | grep nbmerge || pip3 install nbmerge;

        # use nbmerge to combine all slide notebooks into a single notebook
        echo "[nbmerge] Creating a combined notebook for all slides..."
        COMBINED_NOTEBOOK="$SLIDES_DIR"/workshop.ipynb
        nbmerge $SLIDES_DIR/*.ipynb -o $COMBINED_NOTEBOOK;

        # make all slide decks
        jupyter nbconvert --to slides --output-dir "$SLIDES_DIR"/html "$SLIDES_DIR"/*.ipynb;

        # delete the combined notebook
        echo "Cleaning up..."
        rm $COMBINED_NOTEBOOK

        echo "Done!";
    fi
fi
