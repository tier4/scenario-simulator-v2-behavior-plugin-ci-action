#!//bin/bash -l
REPOSITORY_URL=$1
REPOS_PATH=$2
CMAKE_ARGS=$3
ROS_DISTRO=$4

cd /build_image
touch entrypoint.sh
echo "#!/bin/bash -l" >> entrypoint.sh
echo "git config --global url.'https://$GTHUB_TOKEN:x-oauth-basic@github.com/'.insteadOf 'https://github.com/'" >> entrypoint.sh
echo "cd /home/ubuntu/Desktop/behavior_plugin_ws/src" >> entrypoint.sh
echo "git clone ${REPOSITORY_URL} target"  >> entrypoint.sh
echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> entrypoint.sh
echo "vcs import /home/ubuntu/Desktop/behavior_plugin_ws/src < /home/ubuntu/Desktop/behavior_plugin_ws/src/target/${REPOS_PATH}" >> entrypoint.sh
echo "rosdep update" >> entrypoint.sh
echo "rosdep install -iry --from-paths /home/ubuntu/Desktop/behavior_plugin_ws/src --rosdistro $ROS_DISTRO" >> entrypoint.sh
echo "cd /home/ubuntu/Desktop/behavior_plugin_ws" >> entrypoint.sh
echo "pip3 install colcon-lcov-result==0.5.0" >> entrypoint.sh
echo "colcon mixin add default 'https://raw.githubusercontent.com/colcon/colcon-mixin-repository/1ddb69bedfd1f04c2f000e95452f7c24a4d6176b/index.yaml'" >> entrypoint.sh
echo "colcon mixin update default" >> entrypoint.sh
echo "source /home/ubuntu/Desktop/behavior_plugin_ws/install/local_setup.bash && colcon build --event-handlers console_cohesion+ --symlink-install --cmake-args ${CMAKE_ARGS}" >> entrypoint.sh

cd ../
mkdir behavior_plugin_ws
cd /build_image
docker build -t build_image \
    --build-arg ROS_DISTRO="$ROS_DISTRO" \
    . \
    && docker run build_image -v ../behavior_plugin_ws:/home/ubuntu/Desktop/behavior_plugin_ws

cd ../test_image
touch entrypoint.sh
echo "#!/bin/bash -l" >> entrypoint.sh
echo "source /home/ubuntu/Desktop/behavior_plugin_ws/install/local_setup.bash && colcon lcov-result --initial" >> entrypoint.sh
echo "source /home/ubuntu/Desktop/behavior_plugin_ws/install/local_setup.bash && colcon test --event-handlers console_cohesion+ --return-code-on-test-failure" >> entrypoint.sh

docker build -t test_image \
    --build-arg ROS_DISTRO="$ROS_DISTRO" \
    . \
    && docker run test_image -v ../behavior_plugin_ws:/home/ubuntu/Desktop/behavior_plugin_ws