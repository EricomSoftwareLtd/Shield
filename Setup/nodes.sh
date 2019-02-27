#!/bin/bash
############################################
#####   Ericom Shield Nodes            #####
#######################################BH###

KNOWN_LABELS="browser, shield_core, management, netdata"

function show_usage() {
    echo "Usage: $0 [--status] [--add-label | -L <node> <label>...] [--remove-label | -R  <node> <label>...] [--show-labels] [--remove-node] [--help] "
    exit
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    show_usage
fi

if [ -z $1 ]; then
    show_usage
fi

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -s | --status | -status)
        docker node ls
        exit
        ;;
    --show-labels | -show-labels)
        if [ -z $2 ]; then
            echo "Missing Shield Node Name"
            show_usage
        else
            echo
            echo " Labels for Shield Node: $2"
            docker node inspect "$2" | grep -A 4 "Label"
            exit
        fi
        ;;
    --add-label | -L | -add-label)
        if [ -z $2 ] || [ -z $3 ]; then
            echo
            echo "Missing Shield Node Name or Label Name"
            show_usage
        else
            echo
            shift
            NODE=$1
            shift
            while [ $# -ne 0 ]; do
                LABEL=$1
                if [ "$(echo "$KNOWN_LABELS" | grep -c "$LABEL")" -eq 0 ]; then
                    echo "Warning: Label: $LABEL is not a known Shield label($KNOWN_LABELS)"
                    echo
                fi
                echo " Adding Label '$LABEL' for Shield Node '$NODE'"
                docker node update --label-add "${LABEL}=yes" "$NODE"
                shift
            done
            exit
        fi
        ;;
    --remove-label | -R | -remove-label)
        if [ -z $2 ] || [ -z $3 ]; then
            echo
            echo "Missing Node Name"
            show_usage
        else
            echo
            shift
            NODE=$1
            shift
            while [ $# -ne 0 ]; do
                LABEL=$1
                echo " Removing Label '$LABEL' from Shield Node '$NODE'"
                docker node update --label-rm "$LABEL" "$NODE"
                shift
            done
            exit
        fi
        ;;
    --remove-node | -remove-node)
        if [ -z $2 ]; then
            echo
            echo "Missing Node Name"
            show_usage
        else
            echo "Removing Node: $2"
            docker node rm -f "$2"
            exit
        fi
        ;;
    #-h | --help)        -usage)
    *)
        show_usage
        ;;
    esac
    shift
done
