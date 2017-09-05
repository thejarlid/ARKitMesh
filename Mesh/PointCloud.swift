//
//  PointCloud.swift
//  Mesh
//
//  Created by Dilraj Devgun on 9/4/17.
//  Copyright © 2017 Dilraj Devgun. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class PointCloud : SCNNode {
    
    /*
     code to get colour from a world point
     
     let worldPos = sceneView.projectPoint(contentRootNode.worldPosition)
     let colorVector = sceneView.averageColorFromEnvironment(at: worldPos)
     lastColorFromEnvironment = colorVector
     */
    
    var alivePoints:[SCNNode] = []      // array holding all active nodes in the view
    var sleepingPoints:[SCNNode] = []   // array holding old nodes that will be reused
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var lines:[SCNNode] = []
    func updatePointCloud(cloud: ARPointCloud) {
        self.putPointsToSleep(pts: self.alivePoints)    // put all the old nodes to sleep
        
        // for each new point in the cloud recycle old points
        // or make new points in the correct positions
        for i in 0..<cloud.points.count {
            let v = cloud.points[i]
            let n = self.wakeUpPoint()
            n.simdPosition = v
        }
        
        for i in 0..<cloud.points.count/2 {
            let v = cloud.points[i]
            let v2 = cloud.points[i+1]
            let previousPoint = SCNVector3Make(v.x, v.y, v.z)
            let currentPosition = SCNVector3Make(v2.x, v2.y, v2.z)
            let line = lineFrom(vector: previousPoint, toVector: currentPosition)
            let lineNode = SCNNode(geometry: line)
            if lines.count > 100 {
                let first = lines.removeFirst()
                first.removeFromParentNode()
            }
            lines.append(lineNode)
            self.addChildNode(lineNode)
        }
    }
    
    func wakeUpPoint() -> SCNNode {
        // if there are no old points put a new point in there so it can be used
        if self.sleepingPoints.count == 0 {
            let pt = createPoint()
            pt.isHidden = true
            self.addChildNode(pt)
            self.sleepingPoints.append(pt)
        }
        // take the old point out and make it visible
        let point = self.sleepingPoints.removeLast()
        self.alivePoints.append(point)
        point.isHidden = false
        return point
        
    }
    
    func putPointsToSleep(pts: [SCNNode]) {
        // for each alive point hide it put it in the sleeping node array and remove
        // it from the list of alive nodes
        for node in pts {
            node.isHidden = true
            self.sleepingPoints.append(node)
        }
        self.alivePoints.removeAll()
    }
    
    func createPoint() -> SCNNode {
        // makes a new point with a sphere shape and a green transparent colour
        let sphere = SCNSphere(radius: 0.002)
        sphere.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.2186225289, green: 0.8862745166, blue: 0.5149020241, alpha: 0.4680543664)
        return SCNNode(geometry: sphere)
    }
    
    func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        return SCNGeometry(sources: [source], elements: [element])
    }
}
