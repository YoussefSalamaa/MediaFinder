//
//  File.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 6/30/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import UIKit

struct User: Codable {
    let name: String
    let email: String
    let password: String
    let phone: String
    let address: String
    let userImage: CodableImage
}

struct CodableImage: Codable {
    let imageData: Data?
    init(withImage image: UIImage){
        self.imageData = image.jpegData(compressionQuality: 1.0)
    }
    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        return image
    }
}

