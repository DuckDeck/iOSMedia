//
//  Home.swift
//  iOSMedia
//
//  Created by Stan Hu on 2020/9/19.
//  Copyright © 2020 Stan Hu. All rights reserved.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView{
            List{
               
                NavigationLink("OpenCV", destination: OpenCVMenu())
                NavigationLink("FFMpeg", destination: FFMpegMenu())

            }.navigationBarTitle(Text("iOS多媒体"))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
