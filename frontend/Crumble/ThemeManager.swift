//
//  ThemeManager.swift
//  Crumble
//
//  Created by Nathan Stack on 8/12/19.
//  Copyright © 2019 Nathan Stack. All rights reserved.
//

import Foundation
import UIKit

let brownColor = UIColor(red: 76/255, green: 50/255, blue: 37/255, alpha: 1)
let grayColor = UIColor(red: 247/255, green: 236/255, blue: 202/255, alpha: 1)
let orangeColor = UIColor(red: 254/255, green: 164/255, blue: 49/255, alpha: 1)

let crumbleLogo = UIImage(named: "loginlogo")
let googleLogo = UIImage(named: "googleLogo")

func getDefaultAppFont(ofSize size: CGFloat) -> UIFont {
    return UIFont(name: "Montserrat-Regular", size: size)!
}
