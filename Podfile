source 'https://github.com/CocoaPods/Specs.git'

project 'Cordate.xcodeproj'
platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!

target 'Cordate' do
  podspec name: 'Cordate'

  target 'CordateTests' do
    inherit! :search_paths
    pod 'Nimble'
    pod 'Quick'
  end

end

target 'CordateDemo' do
  podspec name: 'Cordate'
end

