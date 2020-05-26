//
//  Shaders.metal
//  Playground
//
//  Created by zpp on 2020/5/26.
//  Copyright © 2020 zpp. All rights reserved.
//

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct VertexIn
{
    float4 position [[attribute(0)]];
};

struct VertexOut
{
    float4 position [[ position ]];
    float point_size [[ point_size]];
};

vertex VertexOut vertex_main(constant float3 *vertices [[buffer(0)]], constant float4x4 &matrix [[buffer(1)]], uint id [[ vertex_id]])
{
    VertexOut out;
    out.position = matrix * float4(vertices[id], 1);
    out.point_size = 20.0f;
    
    return out;
}



fragment float4 fragment_main(constant float4 &color [[ buffer(0)]])
{
    return color;
}
