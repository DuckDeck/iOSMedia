//
//  Model.swift
//  iOSMedia
//
//  Created by Stan Hu on 2020/6/7.
//  Copyright © 2020 Stan Hu. All rights reserved.
//

import CoreLocation
import SwiftUI
import Combine
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

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}

let coor = Coordinates(latitude: 113.2123, longitude: 56.1231)


var data1 = Landmark(id: 1, name: "ShenZhen", imageName: "001", coordinates: coor, state: "USA", park: "Center Park", category: .lakes, isFavorite: true)
var data2 = Landmark(id: 2, name: "GuangZhou", imageName: "a1", coordinates: coor, state: "China", park: "Center Park", category: .mountains, isFavorite: true)
var data3 = Landmark(id: 3, name: "HuiZhou", imageName: "a3", coordinates: coor, state: "Japan", park: "Center Park", category: .lakes, isFavorite: true)
var data4 = Landmark(id: 4, name: "DongGuan", imageName: "a4", coordinates: coor, state: "Aussian", park: "Good Pard", category: .lakes, isFavorite: true)

var landMarkData = [data1,data2,data3,data4]

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var landmarks = landMarkData
}

extension Landmark {
    var image: Image {
        
        ImageStore.shared.image(name: imageName)
    }
    
}



class ImageStore {
    static let shared = ImageStore()
    func image(name:String) -> Image {
        return Image(name)
    }
}
