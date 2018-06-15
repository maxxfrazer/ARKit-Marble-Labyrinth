//
//  MarbleSphere.swift
//  UsingMarkerGravity
//
//  Created by Max Cobb on 13/06/2018.
//  Copyright © 2018 Max Cobb. All rights reserved.
//

import SceneKit

class MarbleSphere: SCNNode {
	public init(radius: CGFloat) {
//		super.init(geometry: SCNSphere(radius: radius))
		super.init()
		let geom = SCNSphere(radius: radius)
		self.geometry = geom
		geom.firstMaterial?.diffuse.contents = UIColor.gray
		self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
		self.physicsBody?.isAffectedByGravity = true
		self.physicsBody?.restitution = 0.05
//		self.physicsBody?.rollingFriction = 1.0
//		self.physicsBody?.friction = 1.0
//		self.physicsBody?.damping = 0.9
		self.position = SCNVector3(0.0, radius, 0.0)
		self.physicsBody?.velocityFactor = SCNVector3(0.8, 0.8, 0.8)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
