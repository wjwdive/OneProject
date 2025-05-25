// The colors are picked up from https://backpack.github.io/guidelines/colors

import UIKit
/// 语义化颜色（Semantic colors）来进行适配。什么叫语义化颜色呢？语义化颜色是我们根据用途来定义颜色的名称，例如使用在背景上的颜色定义为background，主文本和副文本的颜色分别定义为primaryText和secondaryText。
/// 语义化颜色的好处在于，假设我们需要对某个颜色进行修改，只需要修改语义化颜色的定义即可，而不需要去修改每一个使用了这个颜色的地方。这样就避免了重复劳动和错误。
/// 简化深色模式的适配过程，苹果公司提供了具有语义的系统色（System colors）和动态系统色（Dynamic system colors）供我们使用。
public extension UIColor {
    static let designKit = DesignKitPalette.self

    enum DesignKitPalette {
        public static let primary: UIColor = dynamicColor(light: UIColor(hex: 0x0770e3), dark: UIColor(hex: 0x6d9feb))
        public static let background: UIColor = dynamicColor(light: .white, dark: .black)
        public static let secondaryBackground: UIColor = dynamicColor(light: UIColor(hex: 0xf1f2f8), dark: UIColor(hex: 0x1D1B20))
        public static let tertiaryBackground: UIColor = dynamicColor(light: .white, dark: UIColor(hex: 0x2C2C2E))
        public static let line: UIColor = dynamicColor(light: UIColor(hex: 0xcdcdd7), dark: UIColor(hex: 0x48484A))
        public static let primaryText: UIColor = dynamicColor(light: UIColor(hex: 0x111236), dark: .white)
        public static let secondaryText: UIColor = dynamicColor(light: UIColor(hex: 0x68697f), dark: UIColor(hex: 0x8E8E93))
        public static let tertiaryText: UIColor = dynamicColor(light: UIColor(hex: 0x8f90a0), dark: UIColor(hex: 0x8E8E93))
        public static let quaternaryText: UIColor = dynamicColor(light: UIColor(hex: 0xb2b2bf), dark: UIColor(hex: 0x8E8E93))

        static private func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
            return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
        }
    }
}

public extension UIColor {
    convenience init(hex: Int) {
        let components = (
                R: CGFloat((hex >> 16) & 0xff) / 255,
                G: CGFloat((hex >> 08) & 0xff) / 255,
                B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
