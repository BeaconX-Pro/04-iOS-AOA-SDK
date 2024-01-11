#
# Be sure to run `pod lib lint MKBeaconXProACTag.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKBeaconXProACTag'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MKBeaconXProACTag.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/BeaconX-Pro/iOS-AOA-SDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lovexiaoxia' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/BeaconX-Pro/iOS-AOA-SDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'
  
  s.resource_bundles = {
    'MKBeaconXProACTag' => ['MKBeaconXProACTag/Assets/*.png']
  }

  s.subspec 'ConnectManager' do |ss|
    ss.source_files = 'MKBeaconXProACTag/Classes/ConnectManager/**'
    
    ss.dependency 'MKBeaconXProACTag/SDK'
    
    ss.dependency 'MKBaseModuleLibrary'
  end
  
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKBeaconXProACTag/Classes/CTMediator/**'
    
    ss.dependency 'MKBaseModuleLibrary'
    
    ss.dependency 'CTMediator'
  end
  
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKBeaconXProACTag/Classes/SDK/**'
    
    ss.dependency 'MKBaseBleModule'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKBeaconXProACTag/Classes/Target/**'
    
    ss.dependency 'MKBeaconXProACTag/Functions'
  end
  
  
  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AboutPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/AboutPage/Controller/**'
      end
    end
    
    ss.subspec 'AccelerationPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/AccelerationPage/Controller/**'
      
        ssss.dependency 'MKBeaconXProACTag/Functions/AccelerationPage/Model'
        ssss.dependency 'MKBeaconXProACTag/Functions/AccelerationPage/View'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/AccelerationPage/Model/**'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/AccelerationPage/View/**'
      end
    end
    
    ss.subspec 'DeviceInfoPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/DeviceInfoPage/Controller/**'
      
        ssss.dependency 'MKBeaconXProACTag/Functions/DeviceInfoPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/DeviceInfoPage/Model/**'
      end
    end
    
    ss.subspec 'PowerConfigPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/PowerConfigPage/Controller/**'
      
        ssss.dependency 'MKBeaconXProACTag/Functions/PowerConfigPage/Model'
        ssss.dependency 'MKBeaconXProACTag/Functions/PowerConfigPage/View'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/PowerConfigPage/Model/**'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/PowerConfigPage/View/**'
      end
    end
    
    ss.subspec 'QuickSwitchPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/QuickSwitchPage/Controller/**'
      
        ssss.dependency 'MKBeaconXProACTag/Functions/QuickSwitchPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/QuickSwitchPage/Model/**'
      end
    end
    
    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/ScanPage/Controller/**'
      
        ssss.dependency 'MKBeaconXProACTag/Functions/ScanPage/Model'
        ssss.dependency 'MKBeaconXProACTag/Functions/ScanPage/View'
        ssss.dependency 'MKBeaconXProACTag/Functions/ScanPage/Adopter'
        
        ssss.dependency 'MKBeaconXProACTag/Functions/TabBarPage/Controller'
        ssss.dependency 'MKBeaconXProACTag/Functions/AboutPage/Controller'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/ScanPage/View/**'
        
        ssss.dependency 'MKBeaconXProACTag/Functions/ScanPage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/ScanPage/Model/**'
      end
      
      sss.subspec 'Adopter' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/ScanPage/Adopter/**'
        
        ssss.dependency 'MKBeaconXProACTag/Functions/ScanPage/Model'
        ssss.dependency 'MKBeaconXProACTag/Functions/ScanPage/View'
      end
    end
    
    ss.subspec 'SettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/SettingPage/Controller/**'
        
        ssss.dependency 'MKBeaconXProACTag/Functions/SettingPage/Model'
              
        ssss.dependency 'MKBeaconXProACTag/Functions/AccelerationPage/Controller'
        ssss.dependency 'MKBeaconXProACTag/Functions/PowerConfigPage/Controller'
        ssss.dependency 'MKBeaconXProACTag/Functions/QuickSwitchPage/Controller'
        ssss.dependency 'MKBeaconXProACTag/Functions/UpdatePage/Controller'
        
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/SettingPage/Model/**'
      end
    end
    
    ss.subspec 'SlotConfigPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/SlotConfigPage/Controller/**'
      
        ssss.dependency 'MKBeaconXProACTag/Functions/SlotConfigPage/Model'
        ssss.dependency 'MKBeaconXProACTag/Functions/SlotConfigPage/View'
      end
    
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/SlotConfigPage/View/**'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/SlotConfigPage/Model/**'
      end
    end
    
    ss.subspec 'TabBarPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/TabBarPage/Controller/**'
        
        ssss.dependency 'MKBeaconXProACTag/Functions/SlotConfigPage/Controller'
        ssss.dependency 'MKBeaconXProACTag/Functions/SettingPage/Controller'
        ssss.dependency 'MKBeaconXProACTag/Functions/DeviceInfoPage/Controller'
      end
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/UpdatePage/Controller/**'
      
        ssss.dependency 'MKBeaconXProACTag/Functions/UpdatePage/Model'
      end
    
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBeaconXProACTag/Classes/Functions/UpdatePage/Model/**'
      end
    end
    
    ss.dependency 'MKBeaconXProACTag/SDK'
    ss.dependency 'MKBeaconXProACTag/CTMediator'
    ss.dependency 'MKBeaconXProACTag/ConnectManager'
  
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'MKBeaconXCustomUI'
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    ss.dependency 'iOSDFULibrary',    '4.13.0'
    
  end
  
end
