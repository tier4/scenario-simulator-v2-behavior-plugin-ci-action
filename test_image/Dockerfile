ARG ROS_DISTRO
FROM tier4/scenario_simulator_v2:${ROS_DISTRO}
SHELL ["/bin/bash", "-c"]

COPY entrypoint.sh /home/ubuntu/Desktop/entrypoint.sh
RUN ["chmod", "+x", "/home/ubuntu/Desktop/entrypoint.sh"]
ENTRYPOINT ["/home/ubuntu/Desktop/entrypoint.sh"]