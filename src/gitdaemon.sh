#!/bin/bash
/usr/bin/git daemon --reuseaddr --export-all --interpolated-path=/srv/git/%H/\%D
