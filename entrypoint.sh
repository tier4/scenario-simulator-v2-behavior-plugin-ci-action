#!//bin/bash -l
REPOSITORY_NAME=$1
REPOS_PATH=$2
CMAKE_ARGS=$3
ROS_DISTRO=$4
BRANCH=$5

set -e

cd /runtime_image

touch entrypoint.sh
echo "#!/bin/bash -l" >> entrypoint.sh
echo "ACTIONS_RUNTIME_TOKEN=$ACTIONS_RUNTIME_TOKEN" >> entrypoint.sh
echo "export ACTIONS_RUNTIME_TOKEN" >> entrypoint.sh
echo "ACTIONS_RUNTIME_URL=$ACTIONS_RUNTIME_URL" >> entrypoint.sh
echo "export ACTIONS_RUNTIME_URL" >> entrypoint.sh
echo "GITHUB_RUN_ID=$GITHUB_RUN_ID" >> entrypoint.sh
echo "export GITHUB_RUN_ID" >> entrypoint.sh

echo "set -e" >> entrypoint.sh
echo "git config --global url.'https://$GITHUB_TOKEN:x-oauth-basic@github.com/'.insteadOf 'https://github.com/'" >> entrypoint.sh
echo "cd /home/ubuntu/Desktop/behavior_plugin_ws/src" >> entrypoint.sh

echo "figlet Clone Step" >> entrypoint.sh
echo "git clone -b ${BRANCH} https://$GITHUB_TOKEN:x-oauth-basic@github.com/${REPOSITORY_NAME}.git target" >> entrypoint.sh
echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> entrypoint.sh
echo "source /home/ubuntu/Desktop/scenario_simulator_ws/install/local_setup.bash" >> entrypoint.sh

echo "figlet VCS Import Step" >> entrypoint.sh
echo "vcs import /home/ubuntu/Desktop/behavior_plugin_ws/src < /home/ubuntu/Desktop/behavior_plugin_ws/src/target/${REPOS_PATH}" >> entrypoint.sh

echo "figlet Rosdep Step" >> entrypoint.sh
echo "rosdep update" >> entrypoint.sh
echo "rosdep install -iry --from-paths /home/ubuntu/Desktop/behavior_plugin_ws/src --rosdistro ${ROS_DISTRO}" >> entrypoint.sh
echo "cd /home/ubuntu/Desktop/behavior_plugin_ws" >> entrypoint.sh

echo "figlet Install colcon-lcov Step" >> entrypoint.sh
echo "pip3 install colcon-lcov-result==0.5.0" >> entrypoint.sh
echo "pip3 install colcon-mixin" >> entrypoint.sh
echo "colcon mixin add ci 'https://raw.githubusercontent.com/colcon/colcon-mixin-repository/1ddb69bedfd1f04c2f000e95452f7c24a4d6176b/index.yaml'" >> entrypoint.sh
echo "colcon mixin update ci" >> entrypoint.sh

echo "figlet Build Step" >> entrypoint.sh
echo "colcon build --event-handlers console_cohesion+ --symlink-install --cmake-args ${CMAKE_ARGS}" >> entrypoint.sh

echo "figlet Lcov Step" >> entrypoint.sh
echo "colcon lcov-result --initial" >> entrypoint.sh

echo "figlet Run Test Step" >> entrypoint.sh
echo "colcon test --event-handlers console_cohesion+ --return-code-on-test-failure" >> entrypoint.sh
echo "colcon test-result --verbose" >> entrypoint.sh

echo "figlet Upload Step" >> entrypoint.sh
echo "cd /home/ubuntu/Desktop/artifact_controller" >> entrypoint.sh
echo "npm install" >> entrypoint.sh
echo "mkdir -p /home/ubuntu/Desktop/artifacts"  >> entrypoint.sh
echo "tar -cvjf /home/ubuntu/Desktop/artifacts/artifacts.tar.bz2 /home/ubuntu/Desktop/behavior_plugin_ws" >> entrypoint.sh
echo "npm run upload workspace-${ROS_DISTRO} /home/ubuntu/Desktop/artifacts" >> entrypoint.sh

docker build -t runtime_image \
    --build-arg ROS_DISTRO=${ROS_DISTRO} \
    . \
    && docker run runtime_image