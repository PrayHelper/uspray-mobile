#!/bin/sh

#  ci_pre_xcodebuild.sh
#  Runner
#
#  Created by 이학림 on 2023/11/08.
#
echo "start ci_pre_xcodebuild.sh"
brew install cocoapods
echo "after cocoapods install"
pod install
echo "after pod install"
