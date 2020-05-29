Pod::Spec.new do |spec|
  spec.name         = "MJRefreshNormalHeader_LBEmptySourceViewAuto"
  spec.version      = "1.0.0"
  spec.summary      = "对UIScrollView+LBEmptySourceView的功能扩充，当MJRefreshHeader刷新时需要LBEmptySourceView自动隐藏的功能。"
  spec.description  = "对UIScrollView+LBEmptySourceView的功能扩充，当MJRefreshHeader刷新时需要LBEmptySourceView自动隐藏的功能。"
  spec.homepage     = "https://github.com/A1129434577/UIScrollView_LBEmptySourceView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "刘彬" => "1129434577@qq.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.source       = { :git => 'https://github.com/A1129434577/UIScrollView_LBEmptySourceView.git', :tag => spec.version.to_s }
  spec.dependency     "MJRefresh"
  spec.dependency     "UIScrollView_LBEmptySourceView"
  spec.source_files = "MJRefreshNormalHeader+LBEmptySourceViewAuto/**/*.{h,m}"
  spec.requires_arc = true
end
#--use-libraries
