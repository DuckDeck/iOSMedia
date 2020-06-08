//
//  Model.swift
//  iOSMedia
//
//  Created by Stan Hu on 2020/6/7.
//  Copyright © 2020 Stan Hu. All rights reserved.
//

import CoreLocation
import SwiftUI
struct Landmark:Hashable,Codable,Identifiable {
       var id: Int
       var name: String
       fileprivate var imageName: String
       fileprivate var coordinates: Coordinates
       var state: String
       var park: String
       var category: Category
       var isFavorite: Bool

       var locationCoordinate: CLLocationCoordinate2D {
           CLLocationCoordinate2D(
               latitude: coordinates.latitude,
               longitude: coordinates.longitude)
       }

       enum Category: String, CaseIterable, Codable, Hashable {
           case featured = "Featured"
           case lakes = "Lakes"
           case rivers = "Rivers"
           case mountains = "Mountains"
       }
}


let landMarkData = [Landmark]()

extension Landmark {
    var image: Image {
        
        ImageStore.shared.image(name: imageName)
    }
    
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}

class ImageStore {
    static let shared = ImageStore()
    func image(name:String) -> Image {
        return Image(name)
    }
}
