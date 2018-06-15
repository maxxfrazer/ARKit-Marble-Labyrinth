//
//  ViewController.swift
//  ARKit-Labyrinth
//
//  Created by Max Cobb on 15/06/2018.
//  Copyright © 2018 Max Cobb. All rights reserved.
//

import UIKit
import SceneKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate {

	@IBOutlet var sceneView: ARSCNView!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Set the view's delegate
		sceneView.delegate = self

		// Show statistics such as fps and timing information
		sceneView.showsStatistics = true

		// Create a new scene
		//        let scene = SCNScene(named: "art.scnassets/ship.scn")!

		// Set the scene to the view
		sceneView.scene = SCNScene()

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Create a session configuration
		let configuration = ARImageTrackingConfiguration()

		configuration.trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "markers", bundle: Bundle.main)!

		// Run the view's session
		sceneView.session.run(configuration)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		// Pause the view's session
		sceneView.session.pause()
	}

	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard let imageAnchor = anchor as? ARImageAnchor else { return }
		DispatchQueue.global(qos: .background).async {
			let markerNode = MarkerNode(with: imageAnchor)

			// Slwo gravity a little, ball moves too fast
			self.sceneView.scene.physicsWorld.gravity = SCNVector3(0.0,-9.8 / 2,0.0)


			// Add labyrinth to the scene
			node.addChildNode(markerNode)
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
