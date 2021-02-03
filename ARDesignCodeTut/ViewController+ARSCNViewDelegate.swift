//
//  ViewController+ARSCNViewDelegate.swift
//  ARDesignCodeTut
//
//  Created by Hem Poudyal on 12/29/20.
//

import SceneKit
import ARKit

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        //print("Horizontal surface detected")
        
        //create grid
//        let planeAnchor = anchor as! ARPlaneAnchor
//
//        let planeNode = createPlane(planeAnchor: planeAnchor)
//        node.addChildNode(planeNode)
//
        guard focusSquare == nil else {return}
        let focusSquareLocal = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusSquareLocal)
        focusSquare = focusSquareLocal
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // scene is updated 60 times per second - 60fps
        guard anchor is ARPlaneAnchor else { return }
        
//        let planeAnchor = anchor as! ARPlaneAnchor
//
//        //removes
//        node.enumerateChildNodes { (childNode, _) in
//            childNode.removeFromParentNode()
//        }
//
//        //add
//        let planeNode = createPlane(planeAnchor: planeAnchor)
//        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
       // print("Horizontal surface removed")
        
//        node.enumerateChildNodes { (childNode, _) in
//            childNode.removeFromParentNode()
//        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //update frame with system's local time
        //once per frame
        guard let focusSquareLocal = focusSquare else { return }
        
        guard let query = sceneView.raycastQuery(from: screenCenter, allowing: .existingPlaneInfinite, alignment: .any) else {
            return
        }
        
        let hitResults = sceneView.session.raycast(query)
        guard let hitTestResult = hitResults.first else {
            print("No surface found")
            return
        }
        
        let worldTransform = hitTestResult.worldTransform
        let worldTransformColumn3 = worldTransform.columns.3
        focusSquareLocal.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        
        DispatchQueue.main.async {
            self.updateFocusSquare()
        }
    }
    
    func createPlane(planeAnchor: ARPlaneAnchor)-> SCNNode {
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        plane.firstMaterial?.diffuse.contents = UIImage(named: "grid")
        plane.firstMaterial?.isDoubleSided = true
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
       // planeNode.eulerAngles.x = -.pi / 2
        planeNode.eulerAngles.x = GLKMathDegreesToRadians(-90)
        
        return planeNode
    }
}
