#!/bin/bash

## Wrapper for "fortune" allowing the exclusion of certain fortune files.

## 2017-10-05 Geoff Maciolek
## github.com/GeoffMaciolek
#
## KNOWN ISSUES
#
# * This will probably only work on *nix systems, as it counts on '/' as the path delimiter, among other things. Should be OK in cygwin?
# * Doesn't (yet) handle Offensive fortunes, despite the prep script contents. Need to parse '-o' and prepend 'off'


######## BEGIN SCRIPT ########

#### DATA INITIALIZATION ####

## Find fortune file paths - hacky

#	  'fortune -f' gives us the list of files & associated dirs, w/leading percentages, formatted as shown:
#	  100.00% /usr/share/fortune
#	       3.94% men-women
#	       0.07% ascii-art
#	       8.03% definitions
#	       7.69% cookie
#	 
#	  The above is output via stderr (which we redirect).

# Defaults
DoOffensive=false

# We use variables here to prevent (some) unneeded extra executions of 'fortune'
FortuneRawListStandard=$(fortune -f 2>&1) # Store the raw output as-above, for Standard fortunes
FortuneRawListOffensive=$(fortune -fo 2>&1) # Same, for Offensive

# For the path, we only use the lines with '/', and 'cut' to skip the percent (-f2- shows column 2 and onward, in case of spaces in path)
FortunePathStandard=$(fortune -f 2>&1|grep '/'|cut -d' ' -f2-) # Standard files only
FortunePathOffensive=$(grep '/'<<<"$FortuneRawListOffensive"|cut -d' ' -f2-) # Offensive files only

FortuneFilesStandard=$(grep -v '/'<<<"$FortuneRawListStandard"|awk '{printf $2"\n";}') # Get the standard list (Originally used "|rev|cut -d' ' -f1|rev")
FortuneFilesOffensive=$(grep -v '/'<<<"$FortuneRawListOffensive"|awk '{printf $2"\n";}') # Get the offensive list

Usage() {
    echo -e "$0 Usage:"
    echo -e "    $0 (-x/--exclude) fortunefiles,youwant,toexclude --otherfortuneparameters\n"
    echo -e "For usage of 'fortune' itself, see 'man fortune'"
}

#### Parameter parsing ####

if [[ $# -eq 0 ]]; then
    Usage
    exit
fi

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
	-h|--help)
	    Usage
	    exit
	    shift # past argument (not used here)
	    shift # past value
	    ;;
    #    -s|--searchpath)
#	    SEARCHPATH="$2"
#	    shift # past argument
#	    shift # past value
#	    ;;
	-x|--exclude)
	    ExcludeList=$2
	    shift # past argument
	    shift # past value
	    ;;
	--default)
	    DEFAULT=YES
	    shift # past argument
	    ;;
	*)    # unknown option
	    POSITIONAL+=("$1") # save it in an array for later
	    shift # past argument
	;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ $(grep -E '(\-[A-Za-z0-9].o|\-o)'<<<"$@") ]]; then
    DoOffensive=true
    echo "Processing offensive fortunes is not yet implemented, sorry!"
    exit
fi


echo "Standard path: $FortunePathStandard"
echo "Offensive path: $FortunePathOffensive"

#ExcludeFortunes='computers
#drugs
#linux
#politics
#law
#platitudes
#magic'

## We need some logic around this so it functions even if there aren't any exclusions? maybe?

ExcludeFortunes=$(tr ',' "\n" <<<"$ExcludeList")

RemainingFortunes=($(grep -v "$ExcludeFortunes" <<< "$FortuneFilesStandard"))

echo "Remaining options: $@"

fortune $@ "${RemainingFortunes[@]}"
