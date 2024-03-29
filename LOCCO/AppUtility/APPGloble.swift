//
//  APPGloble.swift
//  LOCCO
//
//  Created by Zignuts Technolab on 12/02/24.
//

import UIKit


/// Print given logs to console
func appPrint(_ value: Any...) {
    #if DEBUG
        debugPrint(value)
    #endif
}


class APPGloble {
    //Configure Toast view with defualt value
    static func configureToastView() {
        var toaststyle = ToastStyle()
        toaststyle.backgroundColor = UIColor.appDarkBlue
        toaststyle.titleColor = UIColor.appWhite
        toaststyle.messageColor = UIColor.appWhite
        toaststyle.titleFont = AppFont.regular(size: 15)
        toaststyle.messageFont = AppFont.regular(size: 15)
        ToastManager.shared.style = toaststyle
    }
    
    static var toastStyleWhite:ToastStyle {
        var toastStyleWhite = ToastStyle()
        toastStyleWhite.backgroundColor = UIColor.appWhite
        toastStyleWhite.titleColor = UIColor.appDarkBlue
        toastStyleWhite.messageColor = UIColor.appDarkBlue
        toastStyleWhite.messageFont = AppFont.medium(size: 15)
        toastStyleWhite.titleFont = AppFont.regular(size: 15)
        return toastStyleWhite
    }
    
    static func configureScrollIndicator() {
        UITableView.appearance().showsHorizontalScrollIndicator = false
        UITableView.appearance().showsVerticalScrollIndicator = false
        
        UICollectionView.appearance().showsHorizontalScrollIndicator = false
        UICollectionView.appearance().showsVerticalScrollIndicator = false
        
        UIScrollView.appearance().showsHorizontalScrollIndicator = false
        UIScrollView.appearance().showsVerticalScrollIndicator = false
    }
}


struct AppFont {
    
    static let LSThin = "LondrinaSolid-Thin"
    static let LSLight = "LondrinaSolid-Light"
    static let LSRegular = "LondrinaSolid-Regular"
    static let LSBlack = "LondrinaSolid-Black"
    
    static let MPRegular = "Metropolis-Regular"
    static let MPRegularItalic = "Metropolis-RegularItalic"
    static let MPThin = "Metropolis-Thin"
    static let MPThinItalic = "Metropolis-ThinItalic"
    static let MPExtraLight = "Metropolis-ExtraLight"
    static let MPExtraLightItalic = "Metropolis-ExtraLightItalic"
    static let MPLight = "Metropolis-Light"
    static let MPLightItalic = "Metropolis-LightItalic"
    static let MPMedium = "Metropolis-Medium"
    static let MPMediumItalic = "Metropolis-MediumItalic"
    static let MPSemiBold = "Metropolis-SemiBold"
    static let MPSemiBoldItalic = "Metropolis-SemiBoldItalic"
    static let MPBold = "Metropolis-Bold"
    static let MPBoldItalic = "Metropolis-BoldItalic"
    static let MPExtraBold = "Metropolis-ExtraBold"
    static let MPExtraBoldItalic = "Metropolis-ExtraBoldItalic"
    static let MPBlack = "Metropolis-Black"
    static let MPBlackItalic =  "Metropolis-BlackItalic"
   
    
    static func regular(size:CGFloat)-> UIFont {
        return (UIFont(name: MPRegular, size: size) ?? UIFont.systemFont(ofSize: size))
    }
    
    static func regularItalic(size:CGFloat)-> UIFont {
        return (UIFont(name: MPRegularItalic, size: size) ?? UIFont.systemFont(ofSize: size))
    }
    
    static func thin(size:CGFloat)-> UIFont {
        return (UIFont(name: MPThin, size: size) ?? UIFont.systemFont(ofSize: size, weight: .thin))
    }
    
    static func thinItalic(size:CGFloat)-> UIFont {
        return (UIFont(name: MPThinItalic, size: size) ?? UIFont.systemFont(ofSize: size, weight: .thin))
    }
    
    static func extraLight(size:CGFloat)-> UIFont {
        return (UIFont(name: MPExtraLight, size: size) ?? UIFont.systemFont(ofSize: size, weight: .ultraLight))
    }
    
    static func extraLightItalic(size:CGFloat)-> UIFont {
        return (UIFont(name: MPExtraLightItalic, size: size) ?? UIFont.systemFont(ofSize: size, weight: .ultraLight))
    }
    
    static func light(size:CGFloat)-> UIFont {
        return (UIFont(name: MPLight, size: size) ?? UIFont.systemFont(ofSize: size, weight: .light))
    }
    
    static func lightItalic(size:CGFloat)-> UIFont {
        return (UIFont(name: MPLightItalic, size: size) ?? UIFont.systemFont(ofSize: size, weight: .light))
    }
    
    static func medium(size:CGFloat)-> UIFont {
        return (UIFont(name: MPMedium, size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium))
    }
    
    static func mediumItalic(size:CGFloat)-> UIFont {
        return (UIFont(name: MPMediumItalic, size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium))
    }
    
    static func semiBold(size:CGFloat)-> UIFont {
        return (UIFont(name: MPSemiBold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold))
    }
    
    static func semiBoldItalic(size:CGFloat)-> UIFont {
        return (UIFont(name: MPSemiBoldItalic, size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold))
    }
    
    static func bold(size:CGFloat)-> UIFont {
        return (UIFont(name: MPBold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold))
    }
    
    static func boldItalic(size:CGFloat)-> UIFont {
        return (UIFont(name: MPBoldItalic, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold))
    }
    
    static func extraBold(size:CGFloat)-> UIFont {
        return (UIFont(name: MPExtraBold, size: size) ?? UIFont.systemFont(ofSize: size,weight: .bold))
    }
    
    static func extraBoldItalic(size:CGFloat)-> UIFont {
        return (UIFont(name: MPExtraBoldItalic, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold))
    }
    
    static func black(size:CGFloat)-> UIFont {
        return (UIFont(name: MPBlack, size: size) ?? UIFont.systemFont(ofSize: size, weight: .black))
    }
    
    static func blackItalic(size:CGFloat)-> UIFont {
        return (UIFont(name: MPBlackItalic, size: size) ?? UIFont.systemFont(ofSize: size, weight: .black))
    }
    
    
    static func londrinaThin(size:CGFloat)-> UIFont {
        return (UIFont(name: LSThin, size: size) ?? UIFont.systemFont(ofSize: size,weight: .thin))
    }
    
    static func londrinaBlack(size:CGFloat)-> UIFont {
        return (UIFont(name: LSBlack, size: size) ?? UIFont.systemFont(ofSize: size, weight: .black))
    }
    
    static func londrinaLight(size:CGFloat)-> UIFont {
        return (UIFont(name: LSLight, size: size) ?? UIFont.systemFont(ofSize: size,weight: .light))
    }
    
    static func londrinaRegular(size:CGFloat)-> UIFont {
        return (UIFont(name: LSRegular, size: size) ?? UIFont.systemFont(ofSize: size))
    }
    
    /// Creates and returns a font object for the specified font name and size.
    ///
    /// If font not found then return system regular font with given size
    /// - Parameters:
    ///     - name: The fully specified name of the font. This name incorporates both the font family name and the specific style information for the font.
    ///     - size: The size (in points) to which the font is scaled. This value must be greater than 0.0.
    static func font(name:String, size:CGFloat) -> UIFont{
        return (UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size))
    }
}

class SMHud {
    
    static func animate() {
        SMProcessView.shared.start()
    }
    
    static func dimiss() {
        SMProcessView.shared.stop()
    }
}
