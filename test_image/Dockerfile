FROM build_image
SHELL ["/bin/bash", "-c"]

RUN source /home/ubuntu/Desktop/scenario_simulator_ws/install/local_setup.bash && \
  colcon lcov-result --initial
RUN source /home/ubuntu/Desktop/scenario_simulator_ws/install/local_setup.bash && \
  colcon test --event-handlers console_cohesion+ --return-code-on-test-failure