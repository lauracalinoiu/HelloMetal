//
//  Vertex.swift
//  HelloMetal
//
//  Created by Laura Calinoiu on 09/12/15.
//  Copyright © 2015 3smurfs. All rights reserved.
//

struct Vertex{
    
    var x,y,z: Float     // position data
    var r,g,b,a: Float   // color data
    
    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a]
    }
    
};