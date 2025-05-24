// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Commom {
    /// 你好
    internal static let hello = L10n.tr("Localizable", "Commom.Hello")
    /// 密码
    internal static let password = L10n.tr("Localizable", "Commom.password")
    /// 用户名
    internal static let userName = L10n.tr("Localizable", "Commom.userName")
  }

  internal enum Tracking {
    /// Moments screen
    internal static let momentsScreen = L10n.tr("Localizable", "Tracking.momentsScreen")
  }

  internal enum Development {
    /// Default Configuration
    internal static let defaultConfiguration = L10n.tr("Localizable", "development.defaultConfiguration")
    /// This property has been accessed before the superview has been loaded. Only use this property in `viewDidLoad` or later, as accessing it inside `init` may add a second instance of this view to the hierarchy.
    internal static let fatalErrorAccessedAutomaticallyAdjustedContentViewEarly = L10n.tr("Localizable", "development.fatalErrorAccessedAutomaticallyAdjustedContentViewEarly")
    /// init(coder:) has not been implemented
    internal static let fatalErrorInitCoderNotImplemented = L10n.tr("Localizable", "development.fatalErrorInitCoderNotImplemented")
    /// Subclass has to implement this function
    internal static let fatalErrorSubclassToImplement = L10n.tr("Localizable", "development.fatalErrorSubclassToImplement")
    /// /graphql
    internal static let graphqlPath = L10n.tr("Localizable", "development.graphqlPath")
    /// 运行单元测试中...
    internal static let runningUnitTests = L10n.tr("Localizable", "development.runningUnitTests")
  }

  internal enum InternalMenu {
    /// 51 区
    internal static let area51 = L10n.tr("Localizable", "internalMenu.area51")
    /// 人像
    internal static let avatars = L10n.tr("Localizable", "internalMenu.avatars")
    /// CFBundleVersion
    internal static let cfBundleVersion = L10n.tr("Localizable", "internalMenu.CFBundleVersion")
    /// 颜色
    internal static let colors = L10n.tr("Localizable", "internalMenu.colors")
    /// 闪退 App
    internal static let crashApp = L10n.tr("Localizable", "internalMenu.crashApp")
    /// DesignKit 范例
    internal static let designKitDemo = L10n.tr("Localizable", "internalMenu.designKitDemo")
    /// 点赞按钮
    internal static let favoriteButton = L10n.tr("Localizable", "internalMenu.favoriteButton")
    /// 功能开关
    internal static let featureToggles = L10n.tr("Localizable", "internalMenu.featureToggles")
    /// 通用信息
    internal static let generalInfo = L10n.tr("Localizable", "internalMenu.generalInfo")
    /// 心形点赞按钮
    internal static let heartFavoriteButton = L10n.tr("Localizable", "internalMenu.heartFavoriteButton")
    /// 开启点赞按钮
    internal static let likeButtonForMomentEnabled = L10n.tr("Localizable", "internalMenu.likeButtonForMomentEnabled")
    /// 星形点赞按钮
    internal static let starFavoriteButton = L10n.tr("Localizable", "internalMenu.starFavoriteButton")
    /// 工具箱
    internal static let tools = L10n.tr("Localizable", "internalMenu.tools")
    /// 字体
    internal static let typography = L10n.tr("Localizable", "internalMenu.typography")
    /// 版本号
    internal static let version = L10n.tr("Localizable", "internalMenu.version")
  }

  internal enum MomentsList {
    /// 出错啦，请稍后再试
    internal static let errorMessage = L10n.tr("Localizable", "momentsList.errorMessage")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
