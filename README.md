# Fortune-Wrapper
A crinkly plastic wrapper for "fortune" to allow excluding certain fortune files.

## Why?

There are fortunes on my system (Arch Linux) that are part of the `fortune-mod` package; I don't want to delete them, but I also don't want to see them. `fortune` doesn't offer a way to exclude certain files - only to specify a list.  Hence, this project!

## Getting Started

### Prerequisites

* fortune / fortune-mod
* bash
* A desire to exclude certain fortunes
* Basic \*nix understanding

### Installation

* Clone this repository
* Copy the script to an exectuatble location such as `~/bin` (on some systems) or `/usr/local/bin`
* That's it!

### Usage

`fortunewrap.sh -x some,fortunefiles,toexclude (-l -c...)`

-x or --exclude is followed by a comma-separated list of files to exclude.  Any other parameters (other than -o) will be passed along to fortune.

## Known Issues / Missing features

* Doesn't (yet) handle Offensive fortunes, despite the prep script contents. Need to parse '-o' and prepend 'off'
* This will probably only work on \*nix systems, as it counts on '/' as the path delimiter, among other things. Should be OK in cygwin?

