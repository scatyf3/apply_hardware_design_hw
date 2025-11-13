#!/bin/bash

# Get the directory from which the script was called
project_dir="$(pwd)"

# Derive base name for overlay prefix
base=$(basename "$project_dir")

# Create overlay directory inside the current project folder
overlay_dir="$project_dir/overlay"
mkdir -p "$overlay_dir"

# Find .bit file in the project folder
bitfile=$(find "$project_dir" -name "*.bit" | grep "impl_1" | sort | tail -n 1)

# Handle missing .bit file
if [ -z "$bitfile" ]; then
  echo "❌ No .bit file found in $project_dir. Make sure synthesis and implementation are complete."
  exit 1
fi

# Find corresponding .hwh file
bitbase=$(basename "$bitfile" .bit | sed 's/_wrapper$//')
hwhfile=$(find "$project_dir" -name "${bitbase}.hwh" | head -n 1)

# Handle missing .hwh file
if [ -z "$hwhfile" ]; then
  echo "❌ No .hwh file found in $project_dir. Make sure synthesis and implementation are complete."
  exit 1
fi

# Match .tcl file in same directory as .bit
bitdir=$(dirname "$bitfile")
tclfile=$(find "$bitdir" -name "*.tcl" | head -n 1)

# Handle missing .tcl file
if [ -z "$tclfile" ]; then
  echo "❌ No .tcl file found in $bitdir. Make sure synthesis and implementation are complete."
  exit 1
fi

# Copy and rename overlay files
cp "$bitfile" "$overlay_dir/${base}.bit"
cp "$hwhfile" "$overlay_dir/${base}.hwh"
cp "$tclfile" "$overlay_dir/${base}.tcl"

# Print file info
echo "Source file info:"
for f in "$bitfile" "$hwhfile" "$tclfile"; do
    echo "  $f"
    stat --format="    Last modified: %y" "$f"
done

echo "Overlay files copied to: $overlay_dir/"
echo "  ${base}.bit"
echo "  ${base}.hwh"
echo "  ${base}.tcl"