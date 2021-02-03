//
//  ViewController.swift
//  ARDesignCodeTut
//
//  Created by Hem Poudyal on 12/1/20.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    var focusSquare: FocusSquare?
    var screenCenter: CGPoint!
    var modelsInTheScene: Array<SCNNode> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
        screenCenter = view.center
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/iPhone12/iPhone12.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let viewCenter = CGPoint(x: size.width/2, y: size.height/2)
        screenCenter = viewCenter
    }
    
    func updateFocusSquare(){
        guard let focusSquareLocal = focusSquare else { return }
        
        guard let pointOfView = sceneView.pointOfView else { return }
        
        let firstVisibleModel = modelsInTheScene.first { (node) -> Bool in
            return sceneView.isNode(node, insideFrustumOf: pointOfView)
        }
        
        let modelsAreVisible = firstVisibleModel != nil
        if modelsAreVisible != focusSquareLocal.isHidden {
            focusSquareLocal.setHidden(to: modelsAreVisible)
        }
        
        guard let query = sceneView.raycastQuery(from: screenCenter, allowing: .existingPlaneInfinite, alignment: .horizontal) else {
            return
        }
        
        let hitResults = sceneView.session.raycast(query)
        if let hitTestReuslt = hitResults.first{
            //print("Focus square hits a plane")
            
            let canAddNewModel = hitTestReuslt.anchor is ARPlaneAnchor
            focusSquareLocal.isClosed = canAddNewModel
            
        } else  {
            print("Focus square does not hit a plane")
            focusSquareLocal.isClosed = false
        }
    
    }

    // MARK: - ARSCNViewDelegate
    
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
