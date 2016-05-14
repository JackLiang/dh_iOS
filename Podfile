pod 'AFNetworking', '~> 3.0.4'
pod 'JSONKit'
pod 'MBProgressHUD', '~> 0.9.2'
pod 'SDWebImage', '~> 3.7.3'
pod 'YYModel'
pod 'JDStatusBarNotification'
pod 'CYLTabBarController'

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    if target.name == 'JSONKit'
      target.build_configurations.each do |config|
          config.build_settings['CLANG_WARN_DIRECT_OBJC_ISA_USAGE'] = 'NO'
      end
    end
  end
end