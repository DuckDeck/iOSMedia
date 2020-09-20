//
//  FFMpegMenu.swift
//  iOSMedia
//
//  Created by Stan Hu on 2020/9/20.
//  Copyright © 2020 Stan Hu. All rights reserved.
//

import SwiftUI

struct FFMpegMenu: View {
    var body: some View {
       
            List{
                NavigationLink("Audio Queue 音频解编码", destination: AudioDecoderDemo())
               
                NavigationLink("VideoBox硬解码", destination: VideoBoxDecodeDemo())
            }.navigationBarTitle(Text("OpenCV"))
    }
}

struct FFMpegMenu_Previews: PreviewProvider {
    static var previews: some View {
        FFMpegMenu()
    }
}
