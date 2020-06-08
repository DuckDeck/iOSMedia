//
//  RotatedBadgeSymble.swift
//  iOSMedia
//
//  Created by Stan Hu on 2020/6/8.
//  Copyright © 2020 Stan Hu. All rights reserved.
//

import SwiftUI

struct RotatedBadgeSymble: View {
    let angle:Angle
    var body: some View {
        BadgeSymble().padding(-60).rotationEffect(angle, anchor: .bottom)
    }
}

struct RotatedBadgeSymble_Previews: PreviewProvider {
    static var previews: some View {
        RotatedBadgeSymble(angle: .init(degrees: 5))
    }
}
