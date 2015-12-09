//
//  ViewController.swift
//  HelloMetal
//
//  Created by Laura Calinoiu on 08/12/15.
//  Copyright © 2015 3smurfs. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

class ViewController: UIViewController {
    
    var device: MTLDevice! = nil
    var metalLayer: CAMetalLayer! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    var objectToDraw: Cube! = nil
    var timer: CADisplayLink! = nil
    
    var projectionMatrix: Matrix4!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degreesToRad(85), aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height), nearZ: 0.01, farZ: 100.0)
        device = MTLCreateSystemDefaultDevice()
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .BGRA8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)
        
        objectToDraw = Cube(device: device)
        objectToDraw.positionX = 0.0
        objectToDraw.positionY =  0.0
        objectToDraw.positionZ = -2.0
        objectToDraw.rotationZ = Matrix4.degreesToRad(45);
        objectToDraw.scale = 0.5
        
        let defaultLibrary = device.newDefaultLibrary()
        let fragmentProgram = defaultLibrary!.newFunctionWithName("basic_fragment")
        let vertexProgram = defaultLibrary!.newFunctionWithName("basic_vertex")
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
        
        do {
            pipelineState = try device.newRenderPipelineStateWithDescriptor(pipelineStateDescriptor)
        } catch {
            print("error with device.newRenderPipelineStateWithDescriptor")
        }
        commandQueue = device.newCommandQueue()
        
        timer = CADisplayLink(target: self, selector: "gameloop")
        timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func render() {
        let drawable = metalLayer.nextDrawable()
        objectToDraw.render(commandQueue, pipelineState: pipelineState, drawable: drawable!,projectionMatrix: projectionMatrix, clearColor: nil)
    }
    
    func gameloop(){
        autoreleasepool{
            self.render()
        }
    }
    
}

