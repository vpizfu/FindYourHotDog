//
//  File.swift
//  FindYourFace
//
//  Created by Roman on 9/6/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import Foundation
import UIKit

class CustomData {
    var name: String
    var type: String
    var time: String
    var profileImageUrl: String
    var mainImageUrl: String
    
    init(name: String, type: String, time: String, profileImageUrl: String, mainImageUrl: String) {
        self.name = name
        self.type = type
        self.time = time
        self.profileImageUrl = profileImageUrl
        self.mainImageUrl = mainImageUrl
    }
}
