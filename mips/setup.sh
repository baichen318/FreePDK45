#!/bin/bash

set -ex
cur=$(cd "$(dirname -- "$0")";pwd)
root=${cur}/..
export PDK_DIR=$(root)/FreePDK45/osu_soc

