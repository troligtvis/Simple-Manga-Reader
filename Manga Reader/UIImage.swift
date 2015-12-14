//
//  UIImage.swift
//  Manga Reader
//
//  Created by Kj Drougge on 2015-12-14.
//  Copyright © 2015 kj. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    enum AssetIdentifier: String {
        case Bleach = "logo_bleach"
        case OnePiece = "logo_onepiece"
        case FairyTail = "logo_fairytail"
        case FairyTailZero = "logo_fairytail_zero"
        case NarutoGaiden = "logo_naruto"
        case AttackOnTitan = "logo_attackontitan"
        case AssassinationClassroom = "logo_assassination_classroom"
        case OnePunchMan = "logo_one_punch_man"
    }
    
    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }
}