//
//  AppUser.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 27/07/2026.
//

import Foundation
import SwiftData
import UIKit

@Model
class AppUser {
    var Name : String
    var userName : String
    var profilePath : String?
    
    init(Name: String, userName: String,
         profilePath: String? = nil
    ) {
        self.Name = Name
        self.userName = userName
        self.profilePath = profilePath
    }
    var uiImage: UIImage? {
            guard let imagePath = profilePath else { return nil }
            let url = FileManager.documentsDirectory.appendingPathComponent(imagePath) //
            return UIImage(contentsOfFile: url.path) 
        }
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
