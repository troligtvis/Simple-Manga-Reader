//
//  Serie.swift
//  Manga Reader
//
//  Created by Kj Drougge on 2015-12-14.
//  Copyright © 2015 kj. All rights reserved.
//

import Foundation
import UIKit

enum Serie: Int{
    case Bleach = 0
    case OnePiece
    case FairyTail
    case FairyTailZero
    case NarutoGaiden
    case AttackOnTitan
    case AssassinationClassroom
    case OnePunchMan
    
    func name() -> String{
        switch self{
        case .Bleach:
            return "Bleach"
        case .OnePiece:
            return "One Piece"
        case .FairyTail:
            return "Fairy Tail"
        case .FairyTailZero:
            return "Fairy Tail Zero"
        case .NarutoGaiden:
            return "Naruto Gaiden"
        case .AttackOnTitan:
            return "Attack On Titan"
        case .AssassinationClassroom:
            return "Assassination Classroom"
        case .OnePunchMan:
            return "One Punch Man"
        }
    }
    
    func pageUrl() -> String{
        switch self{
        case .Bleach:
            return "http://www.mangareader.net/94/bleach.html"
        case .OnePiece:
            return "http://www.mangareader.net/103/one-piece.html"
        case .FairyTail:
            return "http://www.mangareader.net/135/fairy-tail.html"
        case .FairyTailZero:
            return "http://www.mangareader.net/fairy-tail-zero"
        case .NarutoGaiden:
            return "http://www.mangareader.net/naruto-gaiden-the-seventh-hokage"
        case .AttackOnTitan:
            return "http://www.mangareader.net/shingeki-no-kyojin"
        case .AssassinationClassroom:
            return "http://www.mangareader.net/assassination-classroom"
        case .OnePunchMan:
            return "http://www.mangareader.net/onepunch-man"
        }
    }
    
    func logoImg() -> UIImage{
        switch self{
        case .Bleach:
            return UIImage(assetIdentifier: .Bleach)
        case .OnePiece:
            return UIImage(assetIdentifier: .OnePiece)
        case .FairyTail:
            return UIImage(assetIdentifier: .FairyTail)
        case .FairyTailZero:
            return UIImage(assetIdentifier: .FairyTailZero)
        case .NarutoGaiden:
            return UIImage(assetIdentifier: .NarutoGaiden)
        case .AttackOnTitan:
            return UIImage(assetIdentifier: .AttackOnTitan)
        case .AssassinationClassroom:
            return UIImage(assetIdentifier: .AssassinationClassroom)
        case .OnePunchMan:
            return UIImage(assetIdentifier: .OnePunchMan)
        }
    }
}