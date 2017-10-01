//
//  Double+RadianExtension.swift
//  SwiftAR
//
//  Created by Thoufeeq Ahamed on 21/09/2017.
//  Copyright © 2017 Thoufeeq Ahamed. All rights reserved.
//

extension Double {
    func toRadians() -> Double {
        return self * .pi / 180.0
    }
    
    func toDegrees() -> Double {
        return self * 180.0 / .pi
    }
}
