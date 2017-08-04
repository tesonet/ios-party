
platform :ios, '10.0'

target 'ios-party' do
    use_frameworks!
pod 'SVProgressHUD'
pod 'RealmSwift'
pod 'ObjectMapper', '~> 2.2'
  # Pods for ios-party

  target 'ios-partyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ios-partyUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end


