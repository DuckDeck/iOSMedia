//
//  Home.swift
//  iOSMedia
//
//  Created by Stan Hu on 2020/6/7.
//  Copyright © 2020 Stan Hu. All rights reserved.
//

import SwiftUI

struct Home: View {
    var categories:[String:[Landmark]]{
        Dictionary(grouping: landMarkData, by: {$0.category.rawValue})
    }
    var featured:[Landmark]{
        landMarkData.filter{$0.isFavorite}
    }
    @State var showingProfile = false
    var profileButton:some View{
        Button(action: {
            self.showingProfile.toggle()
        }) {
            Image(systemName: "person.crop.circle").imageScale(.large).accessibility(label: Text("User Profile")).padding()
        }
    }
    var body: some View {
        NavigationView{List{
            FeaturedLandmarks(landmarks: featured).scaledToFill().frame(height:200).clipped().listRowInsets(EdgeInsets())
            ForEach(categories.keys.sorted(),id: \.self){key in
                CategoryRow(categoryName: key, items: self.categories[key]!)
            }.listRowInsets(EdgeInsets())
            NavigationLink(destination: LandmarkList()) {
                Text("see all")
            }
        }.navigationBarTitle(Text("Featured"))
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: $showingProfile) {
                Text("User Profile")
            }
        }
    }
}

struct FeaturedLandmarks : View{
    var landmarks:[Landmark]
    var body:some View{
        landmarks[0].image.resizable()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
