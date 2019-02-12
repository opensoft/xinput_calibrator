#!/bin/bash

# Copyright 2018, OpenSoft Inc.
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification, are permitted
# provided that the following conditions are met:

#     * Redistributions of source code must retain the above copyright notice, this list of
# conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of
# conditions and the following disclaimer in the documentation and/or other materials provided
# with the distribution.
#     * Neither the name of OpenSoft Inc. nor the names of its contributors may be used to endorse
# or promote products derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Author: denis.kormalev@opensoftdev.com (Denis Kormalev)
# Author: vasiliy.sorokin@opensoftdev.ru (Vasiliy Sorokin)

set -e

DOCKER_IMAGE=opensoftdev/proof-builder-base;
TARGET_NAME=xinput_calibrator

travis_fold start "prepare.docker" && travis_time_start;
echo -e "\033[1;33mDownloading and starting Docker container...\033[0m";
sudo rm -rf $HOME/full_build && mkdir $HOME/full_build;
docker pull $DOCKER_IMAGE:latest;
docker run --privileged -id --name builder -w="/sandbox" \
    -v $(pwd):/sandbox/target_src -v $HOME/proof-bin:/sandbox/proof-bin \
    -v $HOME/builder_ccache:/root/.ccache -v $HOME/full_build:/sandbox/build $DOCKER_IMAGE tail -f /dev/null;
docker ps;
travis_time_finish && travis_fold end "prepare.docker";
echo " ";

travis_fold start "prepare.extra_deps" && travis_time_start;
echo -e "\033[1;33mInstalling extra dependencies...\033[0m";
docker exec -t builder bash -c "apt-get -qq update";
docker exec -t builder bash -c "apt-get -qq install libxi-dev -y --no-install-recommends";
travis_time_finish && travis_fold end "prepare.extra_deps";
echo " ";

travis_fold start "build.qmake" && travis_time_start;
echo -e "\033[1;33mRunning qmake...\033[0m";
echo "$ qmake -r 'QMAKE_CXXFLAGS += -ferror-limit=0 -fcolor-diagnostics' PREFIX='/sandbox/package-$TARGET_NAME' ../target_src/$TARGET_NAME.pro";
docker exec -t builder bash -c "cd build \
    && qmake -r 'QMAKE_CXXFLAGS += -ferror-limit=0 -fcolor-diagnostics' PREFIX='/sandbox/package-$TARGET_NAME' ../target_src/$TARGET_NAME.pro";
travis_time_finish && travis_fold end "build.qmake";
echo " ";

travis_fold start "build.compile" && travis_time_start;
echo -e "\033[1;33mCompiling...\033[0m";
echo "$ make -j4";
docker exec -t builder bash -c "cd build && make -j4";
travis_time_finish && travis_fold end "build.compile";
echo " ";

travis_fold start "build.install" && travis_time_start;
echo -e "\033[1;33mMake install...\033[0m";
echo "$ mkdir -p /sandbox/package-$TARGET_NAME/opt/Opensoft/$TARGET_NAME/ && cd /sandbox/build && make install";
docker exec -t builder bash -c "mkdir -p /sandbox/package-$TARGET_NAME/opt/Opensoft/$TARGET_NAME/ && cp -r /sandbox/target_src/DEBIAN /sandbox/package-$TARGET_NAME/  && cd /sandbox/build && make install";
echo "$ tar -czf package-$TARGET_NAME.tar.gz package-$TARGET_NAME && mv /sandbox/package-$TARGET_NAME.tar.gz /sandbox/build/package-$TARGET_NAME.tar.gz";
docker exec -t builder bash -c "tar -czf package-$TARGET_NAME.tar.gz package-$TARGET_NAME && mv /sandbox/package-$TARGET_NAME.tar.gz /sandbox/build/package-$TARGET_NAME.tar.gz";
travis_time_finish && travis_fold end "build.install";
echo " ";

