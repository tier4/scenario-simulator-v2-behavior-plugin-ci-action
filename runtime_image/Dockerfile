ARG ROS_DISTRO
FROM tier4/scenario_simulator_v2:${ROS_DISTRO}
SHELL ["/bin/bash", "-c"]
RUN mkdir -p /home/ubuntu/Desktop/behavior_plugin_ws/src

COPY entrypoint.sh /home/ubuntu/Desktop/entrypoint.sh
ENTRYPOINT ["/home/ubuntu/Desktop/entrypoint.sh"]