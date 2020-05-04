#!/bin/bash

git clone "https://github.com/FragIt/fragit-main" "$1" && cd "$1" && python setup.py install && cd .. && rm -rf "$1"
