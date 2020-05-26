//
//  Renderer.swift
//  Playground
//
//  Created by zpp on 2020/5/26.
//  Copyright © 2020 zpp. All rights reserved.
//

// Our platform independent renderer class

import Metal
import MetalKit
import simd

class Renderer: NSObject, MTKViewDelegate {

    public let device: MTLDevice!
    let commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!

    var mesh: MTKMesh!
    
    var vertexBuffer: MTLBuffer!
    var timer: Float = 0

    init?(metalKitView: MTKView) {
        self.device = metalKitView.device!
        self.commandQueue = self.device.makeCommandQueue()!

        let mdlMesh = Primitive.makeCube(device: device, size: 1)
        do
        {
            mesh = try MTKMesh(mesh: mdlMesh, device: device)
        }catch let error
        {
            print(error.localizedDescription)
        }
        
        vertexBuffer = mesh.vertexBuffers[0].buffer
        
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        let pipelineDesc = MTLRenderPipelineDescriptor();
        pipelineDesc.vertexFunction = vertexFunction
        pipelineDesc.fragmentFunction = fragmentFunction
        pipelineDesc.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
        pipelineDesc.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        
        do
        {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDesc)
        }catch let error
        {
            fatalError(error.localizedDescription)
        }
        
        
        
        super.init()

    }

    func draw(in view: MTKView) {
        /// Per frame updates hare
        guard let desc = view.currentRenderPassDescriptor,
        let commandBuffer = commandQueue.makeCommandBuffer(),
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: desc)
        else {
            return
        }

        /*timer += 0.05
        var currentTime = sin(timer)
        renderEncoder.setVertexBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 1)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        for submesh in mesh.submeshes
        {
            renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer.buffer, indexBufferOffset: submesh.indexBuffer.offset)
        }*/
        
        var vertices : [SIMD3<Float>] = [
            [-0.7, 0.8, 1],
            [-0,7, -0.4, 1],
            [0.4, 0.2, 1]
        ]
        var matrix = matrix_identity_float4x4
        let scaleX: Float = 1.2
        let scaleY: Float = 0.5
        matrix.columns.0 = [scaleX, 0, 0, 0]
        matrix.columns.1 = [0, scaleY, 0, 0]
        
        /*vertices = vertices.map
        {
            var vertex = SIMD4<Float>($0.x, $0.y, $0.z, 1)
            vertex = matrix * vertex
            return [vertex.x, vertex.y, vertex.z]
        }*/
        renderEncoder.setVertexBytes(&matrix, length: MemoryLayout<float4x4>.stride, index: 1)
        let originalBuffer = device.makeBuffer(bytes: &vertices, length: MemoryLayout<SIMD3<Float>>.stride * vertices.count, options:[])
        renderEncoder.setVertexBuffer(originalBuffer, offset: 0, index: 0)
        
        var lightGrayColor = SIMD4<Float>(0, 1, 0, 1)
        renderEncoder.setFragmentBytes(&lightGrayColor, length: MemoryLayout<SIMD4<Float>>.stride, index: 0)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        /// Respond to drawable size or orientation changes here

    }
}

