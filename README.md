# ZaneAR
iOS ARKit app for Zane

 CLPackages Folder
 ---------------------
 This folder contains files from the ARKit and CoreLocation library: https://github.com/ProjectDent/ARKit-CoreLocation  
 The most important file would be the ‘Scenelocationview.swift’ file. This is basically an extension of ARKit’s ARSCNView class. 
 This adds Apple’s CoreLocation extensions and helper methods that aid in real-time positioning and orientation.  
 
 ViewController.swift 
 ---------------------
 This is the main view that the application runs. 
 The parameter ‘coordinate’ is a hard-coded GPS anchor point (the coordinates are a location pointing to the CDM parking lot). 
 
 In the ‘viewDidLoad()’ method:
 ---------------------
 - authenticate the credentials for Firebase, so that we can write to and read from the remote server.  
 - Setup the SceneLocation subview class. 
 - Get objects stored in the remote server and render them in the scene.  
  
  In the ‘touchesBegan()’ method: 
  ---------------------
  - Set the boolean variable ‘draw’ to know when the user holds the screen.  
  
  In the ‘renderer()’ method: 
  ---------------------
  - Read the boolean variable ‘draw’. 
  - If it is true, render spheres at the phone’s location. As the phone is moved, a continuous line of 3D spheres is rendered.
  - The position of the spheres and the phone itself are pushed to the remote server and stored; these will be read and recreated the next time the user opens the app.  
  
  SCNVector3extensions.swift 
  ---------------------
  An external resource that extends the functionalities of the SCNVector3 class. 
  This file contains helper function including ones to normalise a vector, calculate the distance between two vectors, obtain the cross product, etc.
