#!/bin/bash
############################################
#####   Ericom Shield Nodes            #####
#######################################BH###

function show_usage()
{
    echo "Usage: $0 [-status][-add-label] [-remove-label] [-show-labels] [-usage] "
    exit
}

#Check if we are root
if ((EUID != 0)); then
    #    sudo su
    echo " Please run it as Root"
    echo "sudo $0 $@"
    show_usage
    exit
fi

if [ -z $1 ]; then
   show_usage
fi

while [ $# -ne 0 ]; do
    arg="$1"
    case "$arg" in
    -status)
         docker node ls    
         exit
         ;;
    -show-labels)
       if [ -z $2 ]; then
         echo "Missing Node Name"
         show_usage
        else
          echo
          echo " Labels for Node: $2"
          docker node inspect $2 | grep -A 4 "Label"
          exit
       fi
       ;;
    -add-label)
       if [ -z $2 ] || [ -z $3 ]; then
         echo
         echo "Missing Node Name"
         show_usage
        else
          echo
          echo " Adding Labels for Node: $2"
          docker node update --label-add "$3"="yes" $2
          exit
       fi
       ;;
    -remove-label)
       if [ -z $2 ] || [ -z $3 ]; then
         echo
         echo "Missing Node Name"
         show_usage
        else
          echo
          echo " Removing Labels for Node: $2"
          docker node update --label-rm $3 $2
          exit
       fi
       ;;
    #        -usage)
    *)
        show_usage
        ;;
    esac
    shift
done

