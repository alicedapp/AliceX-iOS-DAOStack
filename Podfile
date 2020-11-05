platform :ios, '11.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

require_relative '../node_modules/@react-native-community/cli-platform-ios/native_modules'
require_relative '../node_modules/react-native/scripts/react_native_pods'

# -------------------------------------------------- #
def vendor
  #  pod 'web3.swift.pod', '~> 2.2.1'

    # Fix release build problem
    pod 'web3swift', git: 'https://github.com/alicedapp/web3swift', branch: 'master'
    
    pod 'KeychainAccess'
    pod 'SPStorkController', git: 'https://github.com/lmcmz/SPStorkController', branch: 'master'
    pod 'SPLarkController'
    pod 'IQKeyboardManagerSwift'
    pod 'HandyJSON', '~> 5.0.3-beta'
#    pod 'HandyJSON', git: 'https://github.com/alibaba/HandyJSON.git' , branch: 'dev_for_swift5.0'
    pod 'Moya', '~> 13.0'
    pod 'SwiftEntryKit', '1.2.3'
    pod 'MarqueeLabel'
    pod 'Hero'
    pod 'Kingfisher'
    pod 'WalletConnectSwift', git: 'https://github.com/WalletConnect/WalletConnectSwift', branch: 'master'
    pod 'HanekeSwift',  git: 'https://github.com/Haneke/HanekeSwift', branch: 'master'
    pod 'BonMot'
    pod 'SwiftyUserDefaults',  git: 'https://github.com/sunshinejr/SwiftyUserDefaults', branch: 'master'
    pod 'TrustWalletCore'
    pod 'VBFPopFlatButton'
    pod "ViewAnimator"
    pod "ESPullToRefresh"
    pod 'JXSegmentedView', git: 'https://github.com/pujiaxin33/JXSegmentedView', branch: 'master'
    pod 'FoldingCell'
    pod 'Pageboy', '~> 3.5.0'
  #  pod 'AwaitKit'
    pod 'Instructions', '~> 1.4.0'
    pod "SkeletonView"
    pod 'SwiftDate', '~> 5.0'
#    pod 'MessageKit'

    pod 'Base64', '~> 1.1'
end

# -------------------------------------------------- #
#def chat
#  pod 'Chatto', '= 3.5.0'
#  pod 'ChattoAdditions', '= 3.5.0'
#  pod 'SwiftMatrixSDK'
#end


# -------------------------------------------------- #
def remote
  #for push notifications
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
  pod 'Firebase/Performance'
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
end


# -------------------------------------------------- #
def rn
  # React Native Dependencies
  pod 'FBLazyVector', :path => "../node_modules/react-native/Libraries/FBLazyVector"
   pod 'FBReactNativeSpec', :path => "../node_modules/react-native/Libraries/FBReactNativeSpec"
   pod 'RCTRequired', :path => "../node_modules/react-native/Libraries/RCTRequired"
   pod 'RCTTypeSafety', :path => "../node_modules/react-native/Libraries/TypeSafety"
   pod 'React', :path => '../node_modules/react-native/'
   pod 'React-Core', :path => '../node_modules/react-native/'
   pod 'React-CoreModules', :path => '../node_modules/react-native/React/CoreModules'
   pod 'React-Core/DevSupport', :path => '../node_modules/react-native/'
   pod 'React-RCTActionSheet', :path => '../node_modules/react-native/Libraries/ActionSheetIOS'
   pod 'React-RCTAnimation', :path => '../node_modules/react-native/Libraries/NativeAnimation'
   pod 'React-RCTBlob', :path => '../node_modules/react-native/Libraries/Blob'
   pod 'React-RCTImage', :path => '../node_modules/react-native/Libraries/Image'
   pod 'React-RCTLinking', :path => '../node_modules/react-native/Libraries/LinkingIOS'
   pod 'React-RCTNetwork', :path => '../node_modules/react-native/Libraries/Network'
   pod 'React-RCTSettings', :path => '../node_modules/react-native/Libraries/Settings'
   pod 'React-RCTText', :path => '../node_modules/react-native/Libraries/Text'
   pod 'React-RCTVibration', :path => '../node_modules/react-native/Libraries/Vibration'
   pod 'React-Core/RCTWebSocket', :path => '../node_modules/react-native/'
   pod 'React-cxxreact', :path => '../node_modules/react-native/ReactCommon/cxxreact'
   pod 'React-jsi', :path => '../node_modules/react-native/ReactCommon/jsi'
   pod 'React-jsiexecutor', :path => '../node_modules/react-native/ReactCommon/jsiexecutor'
   pod 'React-jsinspector', :path => '../node_modules/react-native/ReactCommon/jsinspector'
   pod 'React-callinvoker', :path => "../node_modules/react-native/ReactCommon/callinvoker"
   pod 'ReactCommon/turbomodule/core', :path => "../node_modules/react-native/ReactCommon"
   pod 'Yoga', :path => '../node_modules/react-native/ReactCommon/yoga'
   pod 'DoubleConversion', :podspec => '../node_modules/react-native/third-party-podspecs/DoubleConversion.podspec'
   pod 'glog', :podspec => '../node_modules/react-native/third-party-podspecs/glog.podspec'
   pod 'Folly', :podspec => '../node_modules/react-native/third-party-podspecs/Folly.podspec'
   
#   pod 'CodePush', :path => '../node_modules/react-native-code-push'
end

$RNFirebaseAsStaticFramework = true

# -------------------------------------------------- #
target 'AliceX' do
 use_frameworks!
#  use_native_modules!
  
  vendor
#  chat
  remote
  rn

end

pre_install do |installer|
  def installer.verify_no_static_framework_transitive_dependencies; end
end


post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
    end
  end
end

#post_install do |installer|
#
#  rnfirebase = installer.pods_project.targets.find { |target| target.name == 'RNFirebase' }
#  rnfirebase.build_configurations.each do |config|
#    config.build_settings['HEADER_SEARCH_PATHS'] = '$(inherited) ${PODS_ROOT}/Headers/Public/**'
#  end
#
#  installer.pods_project.build_configurations.each do |config|
#    config.build_settings.delete('CODE_SIGNING_ALLOWED')
#    config.build_settings.delete('CODE_SIGNING_REQUIRED')
#  end
#
#  installer.pods_project.targets.each do |target|
#      target.build_configurations.each do |config|
#          config.build_settings['ENABLE_BITCODE'] = 'YES'
#          config.build_settings['SWIFT_VERSION'] = '5.0'
#      end
#  end
#end
