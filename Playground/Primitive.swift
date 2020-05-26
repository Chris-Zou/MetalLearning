//
//  Primitive.swift
//  Playground
//
//  Created by zpp on 2020/5/26.
//  Copyright © 2020 zpp. All rights reserved.
//

import Foundation
import MetalKit

class Primitive
{
    class func makeCube(device: MTLDevice, size: Float) -> MDLMesh
    {
        let allocator = MTKMeshBufferAllocator(device: device)
        let mesh = MDLMesh(boxWithExtent: [size, size, size], segments: [1, 1, 1], inwardNormals: false, geometryType: .triangles, allocator: allocator)
        
        return mesh
    }
}
