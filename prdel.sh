#!/bin/bash

APP_NAME=$(basename $0)

#output to stderr
show_err () {
    printf "${APP_NAME}: $1.\nTry '$APP_NAME --help' for additional info. \n" >&2
    exit 1
    return
}

#shows help interface
show_help () {
    cat << _EOF_
Correct Using: $APP_NAME --prefix PREFIX -sl SIZE_MIN -sm SIZE_MAX -d DIRECTORY

	--prefix 	 Prefix of necessary files
	-sl		 Minimal size of file
	-sm		 Maximal size of file
	-d --directory	 Directory
	--help		 Show help info and exit
_EOF_
    exit 0
    return
}

SZA=1
SZB=100
PREF=g
DIR=./

while [[ -n "$1" ]]
do
    case "$1" in
        --prefix )
            if [[ -n "$2" ]]
            then
                PREF="$2"
            else
                show_err "'$2' is not a prefix"
            fi
            shift
        ;;

        -sl )
            if [[ "$2" -gt 0 ]]
            then
                SZA="$2"
            else
                show_err "'$2' is not a number"
            fi
            shift
        ;;

	-sm )
	    if [[ "$2" -gt 0 ]]
	    then
		SZB="$2"
	    else
		show_err "'$2' is not a number"
	    fi
	    shift
	;;

	-d | --directory )
	    if [[ -n "$2" ]]
	    then
		DIR="$2"
	    else
		show_err "'$2' is not a directory"
	    fi
	    shift
	;;

        --help )
            show_help
        ;;

        ? )
            show_help
        ;;
    esac
    shift
done

if [[ -z $PREF ]]
then
    show_err "No prefix"
fi

if [[ -z $SZA ]]
then
    show_err "No SIZE_MAX"
fi

if [[ -z $SZB ]]
then
    show_err "No SIZE_MIN"
fi    

find $DIR -name "$PREF*" -type f \( -size -${SZB}c \) -a \( -size +${SZA}c \) -exec rm {} \+

