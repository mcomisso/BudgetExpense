# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'budget-expense' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for budget-expense
#  pod "FSLineChart"
  pod 'SwiftCharts', :git => 'https://github.com/i-schuetz/SwiftCharts.git'
  pod "SwiftDate"
  pod "RealmSwift"
  pod "Material", "~> 2.0"
  target 'budget-expenseTests' do
    inherit! :search_paths
    # Pods for testing
  end

end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
        end
    end
end
