FROM tier4/scenario_simulator_v2:galactic
SHELL ["/bin/bash", "-c"]
RUN mkdir -p /home/ubuntu/Desktop/behavior_plugin_ws/src

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]