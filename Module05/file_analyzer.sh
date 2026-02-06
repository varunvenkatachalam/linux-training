#!/bin/bash

ERROR_LOG="errors.log"

log_error() {
    echo "[ERROR] $1" | tee -a "$ERROR_LOG" >&2
}

show_help() {
cat << EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>   Recursively search directory for keyword
  -f <file>        Search keyword in a specific file
  -k <keyword>     Keyword to search
  --help           Display this help menu

Examples:
  $0 -d logs -k error
  $0 -f script.sh -k TODO
  $0 --help
EOF
}

recursive_search() {
    local dir="$1"
    local keyword="$2"

    for item in "$dir"/*; do
        if [[ -f "$item" ]]; then
            grep -n "$keyword" "$item" 2>>"$ERROR_LOG"
        elif [[ -d "$item" ]]; then
            recursive_search "$item" "$keyword"
        fi
    done
}

if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [[ $# -eq 0 ]]; then
    log_error "No arguments provided. Use --help."
    exit 1
fi

while getopts ":d:f:k:" opt; do
    case "$opt" in
        d) DIRECTORY="$OPTARG" ;;
        f) FILE="$OPTARG" ;;
        k) KEYWORD="$OPTARG" ;;
        :)
            log_error "Option -$OPTARG requires an argument"
            exit 1
            ;;
        \?)
            log_error "Invalid option: -$OPTARG"
            exit 1
            ;;
    esac
done

KEYWORD_REGEX='^[a-zA-Z0-9_]+$'

if [[ -z "$KEYWORD" || ! "$KEYWORD" =~ $KEYWORD_REGEX ]]; then
    log_error "Invalid or empty keyword"
    exit 1
fi

if [[ -n "$FILE" ]]; then
    if [[ ! -f "$FILE" ]]; then
        log_error "File does not exist: $FILE"
        exit 1
    fi

    echo "Searching '$KEYWORD' in file: $FILE"
    grep -n "$KEYWORD" <<< "$(cat "$FILE")"
    echo "Exit status of grep: $?"
    exit 0
fi

if [[ -n "$DIRECTORY" ]]; then
    if [[ ! -d "$DIRECTORY" ]]; then
        log_error "Directory does not exist: $DIRECTORY"
        exit 1
    fi

    echo "Recursively searching '$KEYWORD' in directory: $DIRECTORY"
    recursive_search "$DIRECTORY" "$KEYWORD"
    echo "Script executed using: $0"
    echo "All arguments passed: $@"
    exit 0
fi

log_error "Invalid argument combination. Use --help."
exit 1
