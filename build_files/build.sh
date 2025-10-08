#!/bin/bash

set -ouex pipefail

dnf downgrade -y mt7xxx-firmware-20250311-1.fc42
