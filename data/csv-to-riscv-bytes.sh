#!/bin/bash

if [[ -z "$1" ]]; then
    echo "error: input file not specified"
    exit 1
fi

n_rows=0
n_cols=0

while IFS= read -r line; do
    line="${line%$'\r'}"
    IFS=',' read -ra values <<< "$line"

    if (( n_rows == 0 )); then
        n_cols=${#values[@]}
    fi

    for i in "${!values[@]}"; do
        declare -n current_var="col_$i"

        if (( n_rows == 0 )); then
            current_var="/*${values[i]}*/"
        else
            current_var="$current_var ${values[i]},"
        fi
    done

    ((n_rows++))
done < "$1"

echo "variables: .quad $n_cols"
echo "n_samples: .quad $n_rows"

for ((i=0; i<n_cols; i++)); do
    name=""
    if ((i == n_cols-1)); then
        name="y_data:"
    else
        name="x${i}_data:"
    fi

    declare -n curr_var="col_$i"
    row="${curr_var%,}"
    echo "$name .double $row"
done
