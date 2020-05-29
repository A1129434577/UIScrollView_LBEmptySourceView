Pod::Spec.new do |spec|
  spec.name         = "UIScrollView_LBEmptySourceView"
  spec.version      = "1.0.0"
  spec.summary      = "UIScrollView添加一个无内容的时候空视图根据数据源（包括header和footer）自动展示与消失的功能。"
  spec.description  = "UIScrollView添加一个无内容的时候空视图根据数据源（包括header和footer）自动展示与消失的功能。"
  spec.homepage     = "https://github.com/A1129434577/UIScrollView_LBEmptySourceView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "刘彬" => "1129434577@qq.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.source       = { :git => 'https://github.com/A1129434577/UIScrollView_LBEmptySourceView.git', :tag => spec.version.to_s }
  spec.source_files = "UIScrollView+LBEmptySourceView/**/*.{h,m}"
  spec.requires_arc = true
end
