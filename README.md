# OneProject
iOS project engineering , components in swift 
# 后端项目
[后端接口项目](https://github.com/wjwdive/MomentsServer)

参照说明本地部署测试环境即可使用接口(登录/注册/朋友圈列表...)

## 1、搭建统一配置的swift项目
    1.0 统一的MAC OS版本，统一的Xcode版本（苹果官网下载安装包，而非AppStore下载）
    1.1 安装 固定版本ruby,如：3.3.0。保存版本信息在在项目根目录的.ruby-versoin文件内，方便脚本读取。
    1.2 使用rbenv 管理ruby版本。 使用brew安装。
    1.3 安装bundle, 之后所有的gems都是用bundle来安装。
    1.4 使用bundle安装固定版本的gem(fastlane, cocopods就是gem)，版本好存储在 GemFile文件中
    1.5 配置好基础的 Podfile。使用bundle安装 'bundle exec pod install'
     
    以上brew,ruby,rbenv需确认好版本。安装好bundle之后 所有的pod操作都是用 'bundle exec pod install'操作。
    基础环境搭建好之后，
    工程目录下/scripts/setup.sh 文件执行即可。
    团队成员只需由项目负责人配置好这些基础设施。其他成员把项目down 好，执行setup.sh脚本，即可获得和其他成员一致的开发环境。
    
## 2、组件化
    2.1 先做本地组件化配置。
        可以手动创建或者根据pod指引创建 .podspec要填写正确
        创建好之后，bundle exec pod spec lint 检查配置是否有错
        bundle exec pod install 安装本地库，成功后就能在 Pod项目中看到了
    2.2 本地库升级为私有库，私有库发布为开源库，待叙
        
    2.3 本地库，源文件未导入到Pod中，因为源文件未放置到src中
    
## 3、完善所语言支持和路由
    3.0 多语言支持，英文和中文
        3.0.1 默认语言文件存放在项目根目录的/Resources/zh-Hans.lproj文件中
        3.0.2 其他语言文件存放在项目根目录的/Resources/en.lproj文件中
        3.0.3 使用swiftgen 生成语言文件的swift代码 Strings.swift,在 /Generated/Strings.swift文件中
    3.1 完善路由模块
        3.1.1 统一路由模块，路由协议 Routing，包括regiser,route 两个方法的定义
        3.1.2 路由实现 Router, 
            初始化为单例shared,新定义路由表navigators[path:navigator]，包括实现register,route 两个方法
            //注册路由
            func register(path: String, navigator: Navigating)
            //解析路由并跳转
            func route(to url: URL?, from routingSource: RoutingSource?, using transitionType: TransitionType = .present)
    
        3.1.3 需要配合指定页面的路由器实现跳转
        例如路由器：struct InternalMenuNavigator: Navigating 
        实现路由导航方法：
        func navigate(from viewController: UIViewController, using transitionType: TransitionType, parameters: [String : String]) 
        此方法中还可加入开关控制，只让 内部支持的测试页面可以跳转，如编译时确定的跳转，只让Debug和Internal 的scheme 编译时通过。
            判断通过后，内部再调用 route(to url: URL?, from routingSource: RoutingSource?, using transitionType: TransitionType = .present)方法
## 4、朋友圈基础雏形完成
    可以请求本地接口模拟真实场景，
    朋友圈图片支持多张图片（1-9张），目前还有个小BUG,两张图片时多处空白行
    
    效果图：
<img src="https://github.com/user-attachments/assets/2f922d8e-de5e-468a-8adc-f6d4b27f6885" alt="效果图" style="max-width: 100%; height: auto; display: block; margin: 0 auto;" />
