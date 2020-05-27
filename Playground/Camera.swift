//
//  Camera.swift
//  Playground
//
//  Created by Chriszou on 5/27/20.
//  Copyright © 2020 zpp. All rights reserved.
//

import Foundation

class Camera: Node
{
    var fovDegress: Float = 70
    var fovRadians: Float
    {
        return radians(fromDegrees: fovDegress)
    }
    
    var aspect: Float = 1
    var near: Float = 0.001
    var far: Float = 100
    
    var projectionMatrix: float4x4
    {
        return float4x4(projectionFov: fovRadians, near: near, far: far, aspect: aspect)
    }
    
    var viewMatrix: float4x4
    {
        let translateMatrix = float4x4(translation: position)
        let rotateMatrix = float4x4(rotation: rotation)
        let scaleMatrix = float4x4(scaling: scale)
        return (translateMatrix * scaleMatrix * rotateMatrix).inverse
    }
}
