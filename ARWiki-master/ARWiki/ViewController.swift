//
//  ViewController.swift
//  ARWiki
//
//  Created by Shawn Roller on 10/16/17.
//  Copyright © 2017 OffensivelyBad. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import CoreLocation
import GameplayKit


class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSKView!
    let locationManager = CLLocationManager()
    var location = CLLocation()
    var sightsJSON: JSON!
    var userHeading = 0.0
    var headingCount = 0
    var pages = [WikiPage]()
    var pagesToDisplay: [WikiPage] {
        let sortedPages = self.pages.sorted()
        return sortedPages.count <= 25 ? sortedPages : Array(sortedPages[0...25])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
        
        getLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = AROrientationTrackingConfiguration()
            
        // Run the view's session
        sceneView.session.run(configuration)
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
}
    
// MARK: - ARSKViewDelegate
extension ViewController: ARSKViewDelegate {
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        
        for page in self.pagesToDisplay {
            if String(describing: anchor.identifier) == page.uuid {
                let title = page.title
                let labelNode = SKLabelNode(text: title)
                labelNode.name = "page"
                labelNode.horizontalAlignmentMode = .center
                labelNode.verticalAlignmentMode = .center
                
                let size = labelNode.frame.size.applying(CGAffineTransform(scaleX: 1.1, y: 1.4))
                let backgroundNode = SKShapeNode(rectOf: size, cornerRadius: 10)
                backgroundNode.name = "page"
                backgroundNode.fillColor = UIColor(hue: CGFloat(GKRandomSource.sharedRandom().nextUniform()), saturation: 0.5, brightness: 0.4, alpha: 0.9)
                backgroundNode.strokeColor = backgroundNode.fillColor.withAlphaComponent(1)
                backgroundNode.lineWidth = 2
                
                backgroundNode.addChild(labelNode)
                return backgroundNode
            }
        }
        
        return nil
        
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

// MARK: - LocationManager
extension ViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func getSights() {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(self.location.coordinate.latitude)%7C\(self.location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else { return }
        
        if let data = try? Data(contentsOf: url) {
            self.sightsJSON = JSON(data)
            self.locationManager.startUpdatingHeading()
        }
    }
    
    func createSights() {
        
        // Loop over the pages from wikipedia
        for page in self.sightsJSON["query"]["pages"].dictionaryValue.values {
            
            guard let sceneView = self.view as? ARSKView, let frame = sceneView.session.currentFrame else { return }
            
            // Make a location based on these coordinates
            let locationLat = page["coordinates"][0]["lat"].doubleValue
            let locationLon = page["coordinates"][0]["lon"].doubleValue
            let location = CLLocation(latitude: locationLat, longitude: locationLon)
            
            // Get the distance to this point and calculate the azimuth
            let distance = Float(self.location.distance(from: location))
            let azimuthFromUser = direction(from: self.location, to: location)
            
            // Calculate the angle to that location
            let angle = azimuthFromUser - self.userHeading
            let angleRadians = angle.deg2Rad()
            
            // Create the horizontal rotation matrix
            let rotationHorizontal = simd_float4x4(SCNMatrix4MakeRotation(Float(angleRadians), 1, 0, 0))
            
            // Create the vertical rotation matrix
            let rotationVertical = simd_float4x4(SCNMatrix4MakeRotation(-0.2 + Float(distance / 6000), 0, 1, 0))
            
            // Combine the rotations with the camera rotation
            let rotation = simd_mul(rotationHorizontal, rotationVertical)
            let rotation2 = simd_mul(frame.camera.transform, rotation)
            
            // Create a matrix to position the anchor on the screen then combine it with the combined matrix
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -(distance / 500)
            let transform = simd_mul(rotation2, translation)
            
            // Create a new anchor with the final matrix
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
            let newPage = WikiPage(uuid: String(describing: anchor.identifier), title: page["title"].string ?? "Unknown", distance: distance)
            self.pages.append(newPage)
            
        }
        
    }
    
    func direction(from p1: CLLocation, to p2: CLLocation) -> Double {
        let lat1 = p1.coordinate.latitude.deg2Rad()
        let lon1 = p1.coordinate.longitude.deg2Rad()
        
        let lat2 = p2.coordinate.latitude.deg2Rad()
        let lon2 = p2.coordinate.longitude.deg2Rad()
        
        let lonDelta = lon2 - lon1
        let y = sin(lonDelta) * cos(lon2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lonDelta)
        let radians = atan2(y, x)
        return radians.rad2deg()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error.localizedDescription)
        let alert = UIAlertController(title: "Error getting location!", message: error.localizedDescription, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        
        DispatchQueue.global().async {
            self.getSights()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            self.headingCount += 1
            guard self.headingCount == 2 else { return }
            self.userHeading = newHeading.magneticHeading
            self.locationManager.stopUpdatingHeading()
            self.createSights()
        }
    }
    
}

