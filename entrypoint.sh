#!//bin/bash -l
REPOSITORY_URL=$1
REPOS_PATH=$2
CMAKE_ARGS=$3
ROS_DISTRO=$4

git config --global url.'https://$GTHUB_TOKEN:x-oauth-basic@github.com/'.insteadOf 'https://github.com/'
cd /home/ubuntu/Desktop/behavior_plugin_ws/src
git clone ${REPOSITORY_URL} target
source /opt/ros/$ROS_DISTRO/setup.bash
vcs import /home/ubuntu/Desktop/behavior_plugin_ws/src < /home/ubuntu/Desktop/behavior_plugin_ws/src/target/${REPOS_PATH}
rosdep update
rosdep install -iry --from-paths /home/ubuntu/Desktop/behavior_plugin_ws/src --rosdistro $ROS_DISTRO
cd /home/ubuntu/Desktop/behavior_plugin_ws
pip3 install colcon-lcov-result==0.5.0
colcon mixin add default 'https://raw.githubusercontent.com/colcon/colcon-mixin-repository/1ddb69bedfd1f04c2f000e95452f7c24a4d6176b/index.yaml'
colcon mixin update default
source /home/ubuntu/Desktop/scenario_simulator_ws/install/local_setup.bash && colcon build --event-handlers console_cohesion+ --symlink-install --cmake-args ${CMAKE_ARGS}
source /home/ubuntu/Desktop/scenario_simulator_ws/install/local_setup.bash && colcon lcov-result --initial
source /home/ubuntu/Desktop/scenario_simulator_ws/install/local_setup.bash && colcon test --event-handlers console_cohesion+ --return-code-on-test-failure
