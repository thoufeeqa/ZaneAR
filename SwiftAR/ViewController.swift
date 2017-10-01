//
//  ViewController.swift
//  SwiftAR
//
//  Created by Thoufeeq Ahamed on 19/09/2017.
//  Copyright © 2017 Thoufeeq Ahamed. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import MapKit
import Firebase
import FirebaseDatabase

struct Anchors: Codable{
    let coordinate: String
    let DeviceCoordinate: String
    let AnchorPosition: String
}

let encoder = JSONEncoder()
let coordinate = CLLocationCoordinate2D(latitude: 49.267489, longitude: -123.089787)

//Firebase user object
let user = Auth.auth().currentUser



class ViewController: UIViewController, ARSessionDelegate{

    var sceneLocationView = SceneLocationView()
    var dbref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // FIrebase sign in for anonymous user
        Auth.auth().signInAnonymously() { (user, error) in
            
        }

        //sceneLocationView.run()
        sceneLocationView.showsStatistics = true
        sceneLocationView.showAxesNode = true
        sceneLocationView.orientToTrueNorth = true
        sceneLocationView.autoenablesDefaultLighting = true
        sceneLocationView.showFeaturePoints = true
        

        
        let location = CLLocation(coordinate: coordinate, altitude: 10)
        let image = UIImage(named: "pin")!
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.scaleRelativeToDistance = true
        print("annotationnode pos->", annotationNode.position)
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        let locNode: LocationNode? = sceneLocationView.locationNodes.last
        
        print("LocationNode position in 3d scene->", locNode?.worldPosition as Any)
        

        view.addSubview(sceneLocationView)
        
        getObjectData()
        
//        let circleNode = createSphereNode(with: 0.2, color: .blue)
//        circleNode.position = SCNVector3(0, 0, -1) // 1 meter in front of camera
//        sceneLocationView.scene.rootNode.addChildNode(circleNode)
//        print ("added sphere")

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print ("Touching screen")
        guard let touch = touches.first else {return}
        
        let results = sceneLocationView.hitTest(touch.location(in: sceneLocationView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitFeature = results.last else {return}
        
//        let hitLocaltransform = SCNMatrix4(hitFeature.localTransform)
//        let hitlocalPosition = SCNVector3Make(hitLocaltransform.m41, hitLocaltransform.m42, hitLocaltransform.m43)
//        print ("local transform -> ", hitlocalPosition)
//        print ("anchor -> ", hitFeature.anchor?.identifier as Any)
//        print ("anchor2 -> ", results.last?.anchor?.transform)
        
        
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        print ("HIT Position" , hitPosition)
        
        let hitTransform_m4x4 = matrix_float4x4(hitTransform)
        let newAnchor = ARAnchor(transform: hitTransform_m4x4)
        sceneLocationView.session.add(anchor: newAnchor)
        
        guard let currentLocation = sceneLocationView.currentLocation() else {return}
        print ("Current Location - " , currentLocation)
        let circleNode = createSphereNode(with: 0.15, color: .lightGray)
        circleNode.position = hitPosition // 1 meter in front of camera
        sceneLocationView.scene.rootNode.addChildNode(circleNode)
        
        
        //coordinate pos of locationAnchor
        print("coordinate pos", sceneLocationView.locationNodes.last?.position)
        
        
        //let anchors = Anchors(coordinate: String(coordinate), DeviceCoordinate: String(currentLocation), AnchorPosition: String(hitPosition))
        print ("added sphere")
        
        //
        // Collect coordinate and position data to write to firebase
        let currentLocationLat:Double = currentLocation.coordinate.latitude
        let currentLocationLong:Double = currentLocation.coordinate.longitude
        let currentLocationData = ["longitude":currentLocationLong, "latitude":currentLocationLat]
        let nearestCoordinateAnchor = ["longitude":coordinate.longitude, "latitude":coordinate.latitude]
        let hitPositionData = ["hitPosX":hitPosition.x, "hitPosY":hitPosition.y, "hitPosZ":hitPosition.z]
        let coordinateAnchorScenePostion = ["X":sceneLocationView.locationNodes.last?.position.x,
                                            "Y":sceneLocationView.locationNodes.last?.position.y,
                                            "Z":sceneLocationView.locationNodes.last?.position.z]
        
        //
        //write to firebase
//       self.dbref.child("objects").childByAutoId().setValue(["username": user?.uid,
//
//                                                             "currentLocationLat":currentLocation.coordinate.latitude,
//                                                             "currentLocationLong":currentLocation.coordinate.longitude,
//
//                                                             "hitPositionX":hitPosition.x,
//                                                             "hitPositionY":hitPosition.y,
//                                                             "hitPositionZ":hitPosition.z,
//
//                                                             "nearestCoordinateAnchorLongitude":coordinate.longitude,
//                                                             "nearestCoordinateAnchorLatitude":coordinate.latitude,
//
//
//                                                             "coordinateAnchorScenePositionX":coordinateAnchorScenePostion["X"],
//                                                             "coordinateAnchorScenePositionY":coordinateAnchorScenePostion["Y"],
//                                                             "coordinateAnchorScenePositionZ":coordinateAnchorScenePostion["Z"]])

    }
    
    func instantiateSphereAtPosition(position: SCNVector3){
        let circleNode = self.createSphereNode(with: 0.2, color: .blue)
        circleNode.position = position
        self.sceneLocationView.scene.rootNode.addChildNode(circleNode)
        print ("added sphere")
    }
    
    func getObjectData(){
        
        //
        //get object list from firebase
        
        // ref to firebase db
        dbref = Database.database().reference()
        
        //
        //querying the object list and instantiating spheres
        dbref.child("objects").observeSingleEvent(of: .value, with: {(snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    print ("child=", child)
                    let uniqueKey = child.key as String //get autoID
                    print("uniqeKey=", uniqueKey)
                    self.dbref.child("objects/\(uniqueKey)/").observe(.value, with: { (snapshot) in
                        if let value = snapshot.value as? [String:Any] {
                            
                            let coordinateAnchorScenePositionX = value["coordinateAnchorScenePositionX"] as! Float
                            let coordinateAnchorScenePositionY = value["coordinateAnchorScenePositionY"] as! Float
                            let coordinateAnchorScenePositionZ = value["coordinateAnchorScenePositionZ"] as! Float
                            
                            let hitPositionX = value["hitPositionX"] as! Float
                            let hitPositionY = value["hitPositionY"] as! Float
                            let hitPositionZ = value["hitPositionZ"] as! Float
                            
                            let coordinateAnchorScenePositionVector = SCNVector3Make(coordinateAnchorScenePositionX, coordinateAnchorScenePositionY, coordinateAnchorScenePositionZ)
                            
                            let hitPositionVector = SCNVector3Make(hitPositionX, hitPositionY, hitPositionZ)
                            
                            print ("Got coordinate anchor scene position -> ", coordinateAnchorScenePositionVector)
                            let name = value["username"] as? String ?? ""
                            print("username__", name)
                            
                            let currentCoordinatePosition = self.sceneLocationView.locationNodes.last?.position
                            
                            let vectorBetweenCoordinateAndARObject = SCNVector3Make(hitPositionX-coordinateAnchorScenePositionX,
                                                                                    hitPositionY-coordinateAnchorScenePositionY,
                                                                                    hitPositionZ-coordinateAnchorScenePositionZ)
                            
                            
                            let finalDisplayPos = SCNVector3Make(vectorBetweenCoordinateAndARObject.x + (currentCoordinatePosition?.x)!,
                                                                 vectorBetweenCoordinateAndARObject.y + (currentCoordinatePosition?.y)!,
                                                                 vectorBetweenCoordinateAndARObject.z + (currentCoordinatePosition?.z)!)
                            
                            print ("original Coordinate location", coordinateAnchorScenePositionVector)
                            print ("original hitPosition = ", hitPositionVector)
                            print ("vectorBetweenCoordinateAndObject", vectorBetweenCoordinateAndARObject)
                            print ("current coordinate location", currentCoordinatePosition)
                            print ("final display pos vector = ", finalDisplayPos)
                           
                            self.instantiateSphereAtPosition(position: hitPositionVector)
                            
                        }
                    })
                }
            }
        })
        
        
//        dbref.child("objects").observe(.value, with: {(snapshot) in
//
//            if let result = snapshot.children.allObjects as? [DataSnapshot] {
//
//                for child in result {
//
//                    let orderID = child.key as String //get autoID
//
//                    print("autoid-", orderID
//                            }
//                        }
//                    })
//                }
//            }
//        })
//
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dbref = Database.database().reference()
        sceneLocationView.run()

    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneLocationView.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate

    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()

     return node
     }
     */
    
    func createSphereNode(with radius: CGFloat, color: UIColor) -> SCNNode{
        let geometry = SCNSphere(radius: radius)
        geometry.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: geometry)
        return sphereNode
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


