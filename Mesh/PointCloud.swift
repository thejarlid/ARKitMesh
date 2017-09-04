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
    
    var alivePoints:[SCNNode] = []      // array holding all active nodes in the view
    var sleepingPoints:[SCNNode] = []   // array holding old nodes that will be reused
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePointCloud(cloud: ARPointCloud) {
        self.putPointsToSleep(pts: self.alivePoints)    // put all the old nodes to sleep
        
        // for each new point in the cloud recycle old points
        // or make new points in the correct positions
        for i in 0..<cloud.points.count {
            let v = cloud.points[i]
            let n = self.wakeUpPoint()
            n.simdPosition = v
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
}
