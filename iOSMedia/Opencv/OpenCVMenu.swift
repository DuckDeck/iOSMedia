//
//  openCVMenu.swift
//  iOSMedia
//
//  Created by Stan Hu on 2020/9/19.
//  Copyright © 2020 Stan Hu. All rights reserved.
//

import SwiftUI

struct OpenCVMenu: View {
    var body: some View {
       
            List{
                NavigationLink("示例1，图像变黑白", destination: OpcnCVDemo())
                NavigationLink("视频处理 <蔡徐坤>", destination: ProcessVideoDemo())
                NavigationLink("图像识别(人脸)", destination: ImageRecognitionDemo())
            }.navigationBarTitle(Text("OpenCV"))
    }
    

}



struct openCVMenu_Previews: PreviewProvider {
    static var previews: some View {
        OpenCVMenu()
    }
}
