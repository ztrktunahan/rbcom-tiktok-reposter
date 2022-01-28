platform :ios, '11.2'

target 'TikTokRepost' do

  use_frameworks!

  pod 'SPAlert'
  pod 'SwiftyStoreKit'
  pod 'Alamofire'
  pod 'BulletinBoard'
  pod 'MKProgress'
  pod ‘Hero’
  pod 'lottie-ios'
  pod 'Adjust'
  pod 'Firebase/Analytics'
  pod 'Firebase/RemoteConfig'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
