//
//  Badge.swift
//  iOSMedia
//
//  Created by Stan Hu on 2020/6/8.
//  Copyright © 2020 Stan Hu. All rights reserved.
//

import SwiftUI

struct Badge: View {
    let rotationCount = 8
    
    var badgeSymbles: some View{
        ForEach(0..<rotationCount){ i in
            RotatedBadgeSymble(angle: .init(degrees: Double(i) / Double(self.rotationCount)) * 360.0).opacity(0.5)
        }
        
    }
    var body: some View {
        ZStack{
            BadgeBackground()
            GeometryReader{ geometry in
                self.badgeSymbles.scaleEffect(0.25, anchor: .top).position(x: geometry.size.width / 2.0, y:  0.75 * geometry.size.height)
            }
           
        }.scaledToFit()
            
    }
    

}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge()
    }
}

