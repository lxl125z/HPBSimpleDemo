Pod::Spec.new do |s|
s.name             = "HPBWalletSDK"   #名称
s.version          = "1.0.0"           #版本号
s.summary          = "HPBWalletSDK is a universal docking protocol for digital asset wallets and dapp used on iOS." #简短介绍
s.description      = <<-DESC
HPBWalletSDK is a universal docking protocol for digital asset wallets and dapp used on iOS, which implement by Swift.   #描述
DESC
s.swift_version    = '4.2'
s.homepage         = "https://github.com/lxl125z/HPBSimpleDemo"  #地址
s.license          = { :type => "MIT", :file => "LICENSE" }  #开源协议
s.author           = { "lxl125z" => "960262335@qq.com" }
s.source       = { :git => "https://github.com/lxl125z/HPBSimpleDemo.git", :tag => s.version }
s.platform     = :ios, '8.0'   #支持的平台及版本，这里我们呢用swift，直接上9.0
s.requires_arc = true     #是否使用ARC
s.source_files  = "HPBWalletSDK/*.swift"    #OC可以使用类似这样"Classes/**/*.{h,m}"
#s.source_files = 'WZMarqueeView/*' #表示源文件的路径，注意这个路径是相对podspec文件而言的
# s.public_header_files = 'Classes/**/*.h'
s.frameworks = 'UIKit', 'Foundation'    #所需的framework,多个用逗号隔开
end

