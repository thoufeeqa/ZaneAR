////
////  ViewController.swift
////  SwiftAR
////
////  Created by Thoufeeq Ahamed on 19/09/2017.
////  Copyright © 2017 Thoufeeq Ahamed. All rights reserved.
////
//
//import UIKit
//import SceneKit
//import ARKit
//import CoreLocation
//import MapKit
//
//
//
//class ViewController: UIViewController, ARSessionDelegate{
//    
//    var sceneLocationView = SceneLocationView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        sceneLocationView.run()
//        sceneLocationView.showsStatistics = true
//        sceneLocationView.showAxesNode = true
//        sceneLocationView.orientToTrueNorth = true
//        
//        
//        
//        let coordinate = CLLocationCoordinate2D(latitude: 49.267489, longitude: -123.089787)
//        let location = CLLocation(coordinate: coordinate, altitude: 10)
//        let image = UIImage(named: "pin")!
//        let annotationNode = LocationAnnotationNode(location: location, image: image)
//        
//        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
//        
//        
//        view.addSubview(sceneLocationView)
//        
//    }
//    
//    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    //        print ("Touching screen")
//    //
//    //        let circleNode = createSphereNode(with: 0.2, color: .blue)
//    //        circleNode.position = SCNVector3(0, 0, -1) // 1 meter in front of camera
//    //        sceneLocationView.scene.rootNode.addChildNode(circleNode)
//    //        print ("added sphere")
//    //    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        sceneLocationView.frame = view.bounds
//    }
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        sceneLocationView.run()
//        
//    }
//    
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        // Pause the view's session
//        sceneLocationView.pause()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Release any cached data, images, etc that aren't in use.
//    }
//    
//    // MARK: - ARSCNViewDelegate
//    
//    /*
//     // Override to create and configure nodes for anchors added to the view's session.
//     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//     let node = SCNNode()
//     
//     return node
//     }
//     */
//    func createSphereNode(with radius: CGFloat, color: UIColor) -> SCNNode{
//        let geometry = SCNSphere(radius: radius)
//        geometry.firstMaterial?.diffuse.contents = color
//        let sphereNode = SCNNode(geometry: geometry)
//        return sphereNode
//    }
//    
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//        
//    }
//    
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//        
//    }
//    
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//        
//    }
//}

