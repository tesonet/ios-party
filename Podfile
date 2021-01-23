# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def common_pods
  use_frameworks!
  pod 'KeychainAccess', '~> 4.1'
  pod 'Alamofire', '~> 5.4'
  pod 'PureLayout', '~> 3.1'
  pod 'GRDB.swift', '~> 5.3'
end

target 'ios-party' do
  common_pods

  target 'ios-partyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ios-partyUITests' do
    # Pods for testing
  end
end
