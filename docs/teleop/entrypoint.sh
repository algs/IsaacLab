#!/bin/sh
# Copyright (c) 2025, NVIDIA CORPORATION.  All rights reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

set -e

# Check for EULA acceptance
/eula.sh

# Set environment variables for each coordinate execution
export CONTAINER_NAME=streamer
/coordinate /cloudxr-entrypoint.sh /opt/nvidia/cloudxr/bin/cloudxr-service &

export CONTAINER_NAME=renderer
export CONTAINER_BIRTH_DEPS=streamer
export CONTAINER_DEATH_DEPS=streamer
/coordinate $@ &

wait  # Wait for all background processes
