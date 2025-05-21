# OneProject
iOS project engineering , components in swift 

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
        

