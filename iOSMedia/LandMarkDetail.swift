//
//  LandMarkDetail.swift
//  iOSMedia
//
//  Created by Stan Hu on 2020/6/8.
//  Copyright © 2020 Stan Hu. All rights reserved.
//

import SwiftUI

struct LandMarkDetail: View {
    var landmark:Landmark
    var body: some View {
        Text(landmark.name)
    }
}

struct LandMarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandMarkDetail(landmark: landMarkData.first!)
    }
}
