FROM nvcr.io/nvidia/cloudxr-runtime-early-access:6.0.1-webrtc AS cloudxr-runtime

FROM nvcr.io/nvidia/isaac-lab:2.3.2

USER root

# CloudXR Runtime
COPY --from=cloudxr-runtime /opt/nvidia/cloudxr /opt/nvidia/cloudxr
COPY --from=cloudxr-runtime /entrypoint.sh /cloudxr-entrypoint.sh
COPY --from=cloudxr-runtime /eula.sh /eula.sh
ENV XR_RUNTIME_JSON=/openxr/share/openxr/1/openxr_cloudxr.json \
    XDG_RUNTIME_DIR=/openxr/run \
    XRT_NO_STDIN=true \
    NV_CXR_OUTPUT_DIR=/tmp/cloudxr
RUN chmod +x /cloudxr-entrypoint.sh \
    && mkdir /openxr && chmod o+rw /openxr \
    && mkdir /var/run/utmp \
    && mkdir ${NV_CXR_OUTPUT_DIR} && chmod o+rw ${NV_CXR_OUTPUT_DIR}

# Coordinator
COPY coordinate /coordinate
ENV COORDINATION_DIR=/tmp/coordination-shared
RUN chmod +x /coordinate \
    && mkdir ${COORDINATION_DIR} && chmod o+rw ${COORDINATION_DIR}

COPY entrypoint.sh /entrypoint.sh

COPY ../../scripts/tools/record_demos.py /workspace/isaaclab/scripts/tools/record_demos.py
COPY ../../source/isaaclab/isaaclab/app/app_launcher.py /workspace/isaaclab/source/isaaclab/isaaclab/app/app_launcher.py
# Patch IsaacLab 2.3.2 to expose camera RGB in policy observations for Galbot demo recording.
# https://github.com/billamiable/IsaacLab/commit/d335db3e7820713c2c07612b766a0e980fbfb550
COPY ../../source/isaaclab_tasks/isaaclab_tasks/manager_based/manipulation/stack/config/galbot/stack_rmp_rel_env_cfg.py /workspace/isaaclab/source/isaaclab_tasks/isaaclab_tasks/manager_based/manipulation/stack/config/galbot/stack_rmp_rel_env_cfg.py
RUN chmod +x /entrypoint.sh

# Runtime configurations
ENV NV_DEVICE_PROFILE=auto-webrtc
ENV NV_CXR_FILE_LOGGING=false

ENTRYPOINT ["/entrypoint.sh"]