#!//bin/bash -l
REPOSITORY_URL=$1
REPOS_PATH=$2
CMAKE_ARGS=$3

git config --global url.'https://$GTHUB_TOKEN:x-oauth-basic@github.com/'.insteadOf 'https://github.com/'
cd /home/ubuntu/Desktop/behavior_plugin_ws/src
git clone ${REPOSITORY_URL} target
source /opt/ros/galactic/setup.bash
source /home/ubuntu/Desktop/scenario_simulator_ws/install/local_setup.bash
vcs import /home/ubuntu/Desktop/behavior_plugin_ws/src < /home/ubuntu/Desktop/behavior_plugin_ws/src/target/${REPOS_PATH}
rosdep update
rosdep install -iry --from-paths /home/ubuntu/Desktop/behavior_plugin_ws/src --rosdistro galactic
cd /home/ubuntu/Desktop/behavior_plugin_ws
pip3 install colcon-lcov-result==0.5.0
colcon mixin add default 'https://raw.githubusercontent.com/colcon/colcon-mixin-repository/1ddb69bedfd1f04c2f000e95452f7c24a4d6176b/index.yaml'
colcon mixin update default

cowsay -f stegosaurus Build Step
colcon build --event-handlers console_cohesion+ --symlink-install --cmake-args ${CMAKE_ARGS}
cowsay -f stegosaurus Initialize Lcov Step
colcon lcov-result --initial
cowsay -f stegosaurus Test Step
colcon test --event-handlers console_cohesion+ --return-code-on-test-failure
colcon test-result --verbose