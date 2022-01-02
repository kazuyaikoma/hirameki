# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BrainBot' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BrainBot
  pod 'fluid-slider'
  pod 'UICircularProgressRing'
  pod 'Toast-Swift'
  pod "LINEActivity"
  pod 'paper-onboarding'
  pod 'RAMReel'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if target.name.include?('Realm')
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      end
    end
  end
end
