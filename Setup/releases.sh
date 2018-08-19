#!/usr/bin/env bash


NOT_FOUND_STR="404: Not Found"
ES_repo_versions="https://raw.githubusercontent.com/EricomSoftwareLtd/Shield/master/Setup/Releases.txt"

function run_list_releases() {
    curl -s -S -o "Releases.txt" $ES_repo_versions

    if [ ! -f "Releases.txt" ] || [ $(grep -c "$NOT_FOUND_STR" Releases.txt) -ge 1 ]; then
        echo "Error: cannot download Release.txt, exiting"
        exit 1
    fi
    while true; do
        cat Releases.txt | cut -d':' -f1
        read -p "Please select the Release you want to install/update (1-4):" choice
        case "$choice" in
            "1" | "latest")
                echo 'latest'
                OPTION="1)"
                break
                ;;
            "2")
                echo "2."
                OPTION="2)"
                break
                ;;
            "3")
                echo "3."
                OPTION="3)"
                break
                ;;
            "4")
                echo "4."
                OPTION="4)"
                break
                ;;
            *)
                echo "Error: Not valid option, exiting"
                ;;
        esac
    done
    grep "$OPTION" Releases.txt
    BRANCH=$(grep "$OPTION" Releases.txt | cut -d':' -f2)
    echo "$BRANCH"
}