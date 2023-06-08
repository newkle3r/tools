#!/bin/bash

# Parse command line arguments
files=()
output_path=""

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --files)
        shift
        files=("$@")
        break
        ;;
        --output)
        shift
        output_path="$1"
        ;;
        *)
        echo "Invalid argument: $1"
        echo "Usage: $(pwd)/bashTravel.sh --files file1.py file2.py ... --output $(pwd)/the_result.txt"
        exit 1
        ;;
    esac
    shift
done

# Check if files argument is present
if [ ${#files[@]} -eq 0 ]; then
    echo "Missing files argument"
    echo "Usage:$(pwd)/bashTravel.sh --files file1.py file2.py ... --output $(pwd)/the_result.txt"
    exit 1
fi

# Check if output path is present
if [ -z "$output_path" ]; then
    output_path="$(pwd)/the_result.txt"
fi

# Create output directory if it doesn't exist
output_dir=$(dirname "$output_path")
mkdir -p "$output_dir"

# Function to print file/directory information
print_info() {
    local file="$1"
    local indent="$2"
    
    # Get file information
    local filename=$(basename "$file")
    local filesize=$(du -h "$file" | awk '{print $1}')
    local filelines=$(wc -l < "$file")
    
    # Print file information
    echo -e "${indent}Name: $filename"
    echo -e "${indent}Size: $filesize"
    echo -e "${indent}Lines: $filelines"
    
    # Check if it's a directory
    if [ -d "$file" ]; then
        local next_indent="${indent}\t"
        
        # Iterate over files in the directory
        for entry in "$file"/*; do
            print_info "$entry" "$next_indent"
        done
    fi
}

# Function to check variable usage in a file
check_variable_usage() {
    local file="$1"
    local variable="$2"
    
    # Check if variable is used in the file
    grep -q "\b$variable\b" "$file"
    if [ $? -eq 0 ]; then
        echo "$variable"
    else
        echo "$variable (Not used)"
    fi
}

# Function to check function usage in a file
check_function_usage() {
    local file="$1"
    local function="$2"
    
    # Check if function is used in the file
    grep -q "\b$function\b" "$file"
    if [ $? -eq 0 ]; then
        echo "$function"
    else
        echo "$function (Not used)"
    fi
}

# Function to process a Python file
process_python_file() {
    local file="$1"
    
    # Print file information
    echo "File: $file" >> "$output_path"
    print_info "$file" "" >> "$output_path"
    echo >> "$output_path"
    
    # Extract variables and functions from the file
    local variables=($(grep -oP '^\s*\w+\s*=' "$file" | awk '{print $1}'))
    local functions=($(grep -oP '^\s*def\s+\w+\s*\(' "$file" | awk '{print $2}'))
    
    # Check variable usage
    echo "Variables:" >> "$output_path"
    for variable in "${variables[@]}"; do
        echo -n "$variable: " >> "$output_path"
        check_variable_usage "$file" "$variable" >> "$output_path"
    done
    echo >> "$output_path"
    
    # Check function usage
    echo "Functions:" >> "$output_path"
    for function in "${functions[@]}"; do
        echo -n "$function: " >> "$output_path"
        check_function_usage "$file" "$function" >> "$output_path"
    done
    echo >> "$output_path"
}

# Process each specified file
for file in "${files[@]}"; do
    # Check if the file exists
    if [ -e "$file" ]; then
        process_python_file "$file"
    else
        echo "File not found: $file" >> "$output_path"
    fi
done

echo "Directory tree saved to: $output_path"
