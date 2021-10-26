# How to use?

```yaml
name: test

on:
  workflow_dispatch:
  schedule:
    - cron: 0 0 * * *
  pull_request:
  push:
    branches:
      - master

jobs:
  test:
    runs-on: ubuntu-latest
    name: A test job for scenario-simulator-v2-behavior-plugin-ci-action
    strategy:
      fail-fast: false
      matrix:
        ros_distro: [foxy, galactic]
    steps:
    - name: Run scenario-simulator-v2-behavior-plugin-ci-action action
      uses: tier4/scenario-simulator-v2-behavior-plugin-ci-action@master
      with:
        repository_name: tier4/context_gamma_planner
        cmake_args: -DWITH_INTEGRATION_TEST=ON
        ros_distro: ${{ matrix.ros_distro }}
      env:
        GITHUB_TOKEN: ${{ secrets.CLONE_TOKEN }} 
```

|      name       |                                        description                                        | required |                                                             default                                                             |
| --------------- | ----------------------------------------------------------------------------------------- | -------- | ------------------------------------------------------------------------------------------------------------------------------- |
| repository_name | repository name of behavior plugin github repository, such as tier4/context_gamma_planner | true     |                                                                                                                                 |
| repos_path      | relative repos yaml path in your repository                                               | false    | dependency.yaml                                                                                                                 |
| cmake_args      | arguments after --cmake_args in colcon build                                              | false    | -DWITH_INTEGRATION_TEST=ON  -DCMAKE_CXX_FLAGS='-fprofile-arcs -ftest-coverage' -DCMAKE_C_FLAGS='-fprofile-arcs -ftest-coverage' |
| ros_distro      | ros distribution currently support galactic and foxy                                      | false    | galactic                                                                                                                        |

# How it works?

This action starts alpine linux docker container, and run tier4/scenario_simulator_v2 image inside alpine linux docker container.
This action only runs colcon build and colcon test for target packages inside docker container and output it's result.