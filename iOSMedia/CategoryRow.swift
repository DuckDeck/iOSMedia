//
//  CategoryRow.swift
//  iOSMedia
//
//  Created by Stan Hu on 2020/6/8.
//  Copyright © 2020 Stan Hu. All rights reserved.
//

import SwiftUI

struct CategoryRow: View {
    var categoryName:String
    var items:[Landmark]
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(self.categoryName).font(.headline).padding(.leading,15).padding(.top,5)
            ScrollView(.horizontal,showsIndicators: false){
                HStack(alignment: .top, spacing: 0){
                    ForEach(self.items){landmark in
                           CategoryItem(landmark: landmark)
                    }
                }
            }.frame(height:185)
        }
    }
}

struct CategoryItem:View {
    var landmark :  Landmark
    var body: some View{
        VStack(alignment: .leading, spacing: 0) {
            landmark.image.resizable().frame(width:155,height:155).cornerRadius(5)
            Text(landmark.name).font(.caption)
        }.padding(.leading,15)
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(categoryName: landMarkData[0].category.rawValue, items: Array(landMarkData.prefix(3)))
    }
}

