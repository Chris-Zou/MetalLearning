//
//  Node.swift
//  Playground
//
//  Created by Chriszou on 5/27/20.
//  Copyright © 2020 zpp. All rights reserved.
//

import MetalKit

class Node
{
    var name: String = "untitled"
    var position: SIMD3<Float> = [0, 0, 0]
    var rotation: SIMD3<Float> = [0, 0, 0]
    var scale: SIMD3<Float> = [1, 1, 1]
    
    var modelMatrix: float4x4
    {
        let translateMatrix = float4x4(translation: position)
        let rotationMatrix = float4x4(rotation: rotation)
        let scaleMatrix = float4x4(scaling: scale)
        
        return translateMatrix * rotationMatrix * scaleMatrix
    }
}
