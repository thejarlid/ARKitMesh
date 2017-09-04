//
//  ViewController.swift
//  Mesh
//
//  Created by Dilraj Devgun on 9/3/17.
//  Copyright © 2017 Dilraj Devgun. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    let session = ARSession()
    let standardConfiguration = ARWorldTrackingConfiguration()
    var pointCloud:PointCloud!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.run(standardConfiguration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func setupScene() {
        sceneView.antialiasingMode = .multisampling4X
        sceneView.automaticallyUpdatesLighting = false
        
        sceneView.preferredFramesPerSecond = 60
        sceneView.contentScaleFactor = 1.3
        
        if let camera = sceneView.pointOfView?.camera {
            camera.wantsHDR = true
            camera.wantsExposureAdaptation = true
            camera.exposureOffset = -1
            camera.minimumExposure = -1
            camera.maximumExposure = 3
        }
        session.delegate = self
        sceneView.delegate = self
        sceneView.session = session
        
        self.pointCloud = PointCloud()
        self.sceneView.scene.rootNode.addChildNode(self.pointCloud)
    }

    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if let cloud = frame.rawFeaturePoints {
            self.pointCloud.updatePointCloud(cloud: cloud)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
