script_dir=$(cd "$(dirname "$0")";pwd)

# build TwitterSignInV1
cd ${script_dir}/../TwitterSignInV1
xcodebuild archive -scheme 'TwitterSignInV1' -configuration Release -destination 'generic/platform=iOS' -archivePath '../build/archives/TwitterSignInV1-iOS.xcarchive' SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive -scheme 'TwitterSignInV1' -configuration Release -destination 'generic/platform=iOS Simulator' -archivePath '../build/archives/TwitterSignInV1-iOS-Simulator.xcarchive' SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


# build TwitterSignInV2
cd ${script_dir}/../TwitterSignInV2
xcodebuild archive -scheme 'TwitterSignInV2' -configuration Release -destination 'generic/platform=iOS' -archivePath '../build/archives/TwitterSignInV2-iOS.xcarchive' SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive -scheme 'TwitterSignInV2' -configuration Release -destination 'generic/platform=iOS Simulator' -archivePath '../build/archives/TwitterSignInV2-iOS-Simulator.xcarchive' SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES


cd ${script_dir}/../build/archives
xcodebuild -create-xcframework -framework 'TwitterSignInV1-iOS.xcarchive/Products/Library/Frameworks/TwitterSignInV1.framework' -framework 'TwitterSignInV1-iOS-Simulator.xcarchive/Products/Library/Frameworks/TwitterSignInV1.framework' -output 'Frameworks/TwitterSignInV1.xcframework'

xcodebuild -create-xcframework -framework 'TwitterSignInV2-iOS.xcarchive/Products/Library/Frameworks/TwitterSignInV2.framework' -framework 'TwitterSignInV2-iOS-Simulator.xcarchive/Products/Library/Frameworks/TwitterSignInV2.framework' -output 'Frameworks/TwitterSignInV2.xcframework'