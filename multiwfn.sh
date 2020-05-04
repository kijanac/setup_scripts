#!/bin/bash

export multiwfn_name='Multiwfn_3.6_bin_Linux'

wget -P "$1" "http://sobereva.com/multiwfn/misc/$multiwfn_name.zip" && cd "$i"

unzip "$multiwfn_name.zip" && rm "$multiwfn_name.zip" && chmod +x "$multiwfn_name/Multiwfn"
