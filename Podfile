# Uncomment this line to define a global platform for your project
platform :ios, '10.0'

target 'budget-expense' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for budget-expense
#  pod "FSLineChart"
  pod 'SwiftCharts', :git => 'https://github.com/i-schuetz/SwiftCharts.git'
  pod "SwiftDate"
  pod "RealmSwift"
  pod "Material", "~> 2.0"
  pod "Crashlytics"
  pod "SQFeedbackGenerator"
  pod "Presentr"
  pod 'Iconic', :git => 'https://github.com/dzenbot/Iconic.git', :tag => '1.3'
  pod 'PKHUD', '~> 4.0'
  pod 'KDCircularProgress'
  pod 'AcknowList'
  pod "R.swift"
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'Eureka'
  target 'budget-expenseTests' do
    inherit! :search_paths
    # Pods for testing
  end

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
	    config.build_settings['ENABLE_BITCODE'] = 'YES'
        end
    end
end
