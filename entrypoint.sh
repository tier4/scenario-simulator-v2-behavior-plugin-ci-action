#!//bin/bash -l
REPOS_YAML=$1
CMAKE_ARGS=$2

git config --global url."https://$GTHUB_TOKEN:x-oauth-basic@github.com/".insteadOf "https://github.com/"
cd /home/ubuntu/Desktop/behavior_plugin_ws/src
echo $REPOS_YAML > packages.repos
cat REPOS_YAML
vcs import . < packages.repos
source /opt/ros/galactic/setup.bash
source /home/ubuntu/Desktop/scenario_simulator_ws/install/local_setup.bash
rosdep update
rosdep install -iry --from-paths /home/ubuntu/Desktop/behavior_plugin_ws/src --rosdistro $ROS_DISTRO
cd /home/ubuntu/Desktop/behavior_plugin_ws
colcon build --symlink-install --cmake-args ${CMAKE_ARGS}