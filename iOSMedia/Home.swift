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
    var body: some View {
        NavigationView{Text("Hello World!!!").navigationBarTitle(Text("Featured"))}
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
