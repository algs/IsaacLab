ACCEPT_EULA=Y USE_RELATIVE_MODE=true /entrypoint.sh ./isaaclab.sh -p scripts/tools/record_demos.py \
  --task Isaac-Stack-Cube-Galbot-Left-Arm-Gripper-Visuomotor-v0 \
  --teleop_device handtracking \
  --enable_cameras \
  --info \
  --rendering_mode quality \
  --dataset_file ./datasets/galbot_left_visuomotor_handtracking.hdf5 \
  --num_demos 0 \
  --num_success_steps 10 \
  --headless