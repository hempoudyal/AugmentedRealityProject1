//
//  ViewController+ObjectAddition.swift
//  ARDesignCodeTut
//
//  Created by Hem Poudyal on 2/2/21.
//

import UIKit
import SceneKit
import ARKit

extension ViewController {

    fileprivate func getModel(named name: String) -> SCNNode? {
        let scene = SCNScene(named: "art.scnassets/\(name)/\(name).scn")
        guard let model = scene?.rootNode.childNode(withName: "SketchUp", recursively: false) else { return nil }
        model.name = name
        
        var scale: CGFloat
        switch name {
        case "iPhone12":
            scale = 0.0001
        default:
            scale = 1
        }
        
        model.scale = SCNVector3(scale, scale, scale)
        
        let min = model.boundingBox.min
        let max = model.boundingBox.max
        model.pivot = SCNMatrix4MakeTranslation(
            min.x + (max.x - min.x) / 2,
            min.y + (max.y - min.y) / 2,
            min.z + (max.z - min.z) / 2)
        return model
    }
    
    @IBAction func addObjectTapped(_ sender: Any) {
        print("Add button tapped")
        
        guard focusSquare != nil else { return }
        
        let modelName = "iPhone12"
        guard let model = getModel(named: modelName) else {
            print("Unable to load \(modelName) from file")
            return
        }
        
        guard let query = sceneView.raycastQuery(from: screenCenter, allowing: .existingPlaneInfinite, alignment: .any) else {
            return
        }
        
        let hitResults = sceneView.session.raycast(query)
        guard let worldTransformColumn3 =  hitResults.first?.worldTransform.columns.3 else { return }
        model.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
        
        sceneView.scene.rootNode.addChildNode(model)
        print("\(modelName) added successfully")
        
        modelsInTheScene.append(model)
        print("Currently have \(modelsInTheScene.count) in the scene.")
    }
    
}
