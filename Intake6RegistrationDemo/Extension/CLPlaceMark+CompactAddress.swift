//
//  CLPlaceMark+CombactAddress.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 7/13/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import MapKit

extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
            var result = name
            if let street = thoroughfare {
                result += ", \(street)"
            }
            if let city = locality {
                result += ", \(city)"
            }
            if let country = country{
                result += ", \(country)"
            }
            return result
        }
        return nil
    }
}
