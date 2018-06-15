//
//  MarkerNodeLoc.swift
//  UsingMarkerGravity
//
//  Created by Max Cobb on 13/06/2018.
//  Copyright © 2018 Max Cobb. All rights reserved.
//

import UIKit
import ARKit

public class MarkerNode: SCNNode {
	var wallHeight: CGFloat = 0.5
	var wallWidth: CGFloat {
		return 0.0
	}
	var sphereSize: CGFloat = 0.0035
	var activeSphere: SCNNode
	var wallNodes = [SCNNode]()
	var ballNodes = [SCNNode]()
	var anchorParent: ARImageAnchor
	var nodeSize: CGSize {
		return self.anchorParent.referenceImage.physicalSize
	}
	var wallGeometry: SCNGeometry {
		let floor = SCNFloor()
		floor.reflectivity = 0.0
		floor.firstMaterial?.diffuse.contents = UIColor.clear
		return floor
	}
	var usingFloor = true
//	var staticPhysicsBody =
	public init(with imageAnchor: ARImageAnchor) {
		self.anchorParent = imageAnchor
		self.activeSphere = SCNNode()
		super.init()
//		self.geometry = SCNBox(width: anchorParent.referenceImage.physicalSize.width, height: anchorParent.referenceImage.physicalSize.height, length: 0.01, chamferRadius: 0.0)
		if !usingFloor {
			let bezPath = UIBezierPath()
			bezPath.move(to: CGPoint(x: -nodeSize.width * 0.55, y: -nodeSize.height * 0.55))
			bezPath.addLine(to: CGPoint(x: -nodeSize.width * 0.55, y: nodeSize.height * 0.55))
			bezPath.addLine(to: CGPoint(x: nodeSize.width * 0.55, y: nodeSize.height * 0.55))
			bezPath.addLine(to: CGPoint(x: nodeSize.width * 0.55, y: -nodeSize.height * 0.55))
			bezPath.close()
			//		bezPath.usesEvenOddFillRule = true
			let floorNode = SCNNode(geometry: SCNShape(path: bezPath, extrusionDepth: 0.01))
			floorNode.eulerAngles.x = Float.pi / 2
			self.addChildNode(floorNode)
			floorNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: nil)
//			self.geometry =
		} else {
			self.geometry = SCNFloor()
			self.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: nil)
			self.physicsBody?.friction = 1.0
		}
//		self.geometry = SCNPlane(width: nodeSize.width, height: nodeSize.height)
//		self.geometry?.materials = [SCNMaterial()]
		self.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
		self.addWalls()
		self.addBall(to: SCNVector3(0, self.sphereSize * 1.05,self.nodeSize.height * 0.4))
		self.addStyle()
	}

	func addStyle() {
		let geomSize = self.nodeSize
		let nodeGeom = SCNPlane(width: geomSize.width, height: geomSize.height)
		let floorPlane = SCNNode(geometry: nodeGeom)
		floorPlane.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "wood_floor")
		let scaleX = (Float(geomSize.width)  / 0.026).rounded()
		let scaleY = (Float(geomSize.height) / 0.02).rounded()
		nodeGeom.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(scaleX, scaleY, 0.0)
		nodeGeom.firstMaterial?.diffuse.wrapS = .repeat
		nodeGeom.firstMaterial?.diffuse.wrapT = .repeat
		floorPlane.eulerAngles.x = -Float.pi / 2
		self.addChildNode(floorPlane)
		let bezPath = UIBezierPath()
		bezPath.move(to: CGPoint(x: -nodeSize.width * 0.6, y: -(nodeSize.height * 0.5 + nodeSize.width * 0.1)))
		bezPath.addLine(to: CGPoint(x: -nodeSize.width * 0.6, y: (nodeSize.height * 0.5 + nodeSize.width * 0.1)))
		bezPath.addLine(to: CGPoint(x: nodeSize.width * 0.6, y: (nodeSize.height * 0.5 + nodeSize.width * 0.1)))
		bezPath.addLine(to: CGPoint(x: nodeSize.width * 0.6, y: -(nodeSize.height * 0.5 + nodeSize.width * 0.1)))
		bezPath.close()
		bezPath.move(to: CGPoint(x: -nodeSize.width * 0.5, y: -nodeSize.height * 0.5))
		bezPath.addLine(to: CGPoint(x: -nodeSize.width * 0.5, y: nodeSize.height * 0.5))
		bezPath.addLine(to: CGPoint(x: nodeSize.width * 0.5, y: nodeSize.height * 0.5))
		bezPath.addLine(to: CGPoint(x: nodeSize.width * 0.5, y: -nodeSize.height * 0.5))
		bezPath.close()
		bezPath.usesEvenOddFillRule = true

		let outsideWalls = SCNShape(path: bezPath, extrusionDepth: sphereSize * 2)
		let newNode = SCNNode(geometry: outsideWalls)
		outsideWalls.firstMaterial?.diffuse.contents = UIImage(named: "wood")
		newNode.eulerAngles.x = Float.pi / 2
		newNode.position.y = Float(sphereSize)
		self.addChildNode(newNode)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	public func addWalls() {
		let wallT = SCNNode(geometry: self.wallGeometry)
		wallT.position = SCNVector3(0.0, 0.0, -(self.nodeSize.height - wallWidth) / 2)
		wallT.eulerAngles.x = Float.pi / 2
		let wallB = SCNNode(geometry: self.wallGeometry)
		wallB.position = SCNVector3(0.0, 0.0, (self.nodeSize.height - wallWidth) / 2)
		wallB.eulerAngles.x = -Float.pi / 2
		let wallL = SCNNode(geometry: self.wallGeometry)
		wallL.position = SCNVector3((self.nodeSize.width - wallWidth) / 2, 0.0, 0.0)
		wallL.eulerAngles.z = Float.pi / 2
		let wallR = SCNNode(geometry: self.wallGeometry)
		wallR.position = SCNVector3(-(self.nodeSize.width - wallWidth) / 2, 0.0, 0.0)
		wallR.eulerAngles.z = -Float.pi / 2
		let wallC = SCNNode(geometry: self.wallGeometry)
		wallC.position = SCNVector3(0.0, self.sphereSize * 2.1, 0.0)
		wallC.eulerAngles.z = Float.pi
		self.wallNodes.append(contentsOf: [wallT, wallB, wallL, wallR, wallC])
		self.wallNodes.forEach { (wall) in
			wall.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: nil)
			self.addChildNode(wall)
		}
		let centreBlock = SCNNode(geometry: SCNBox(width: self.nodeSize.width / 1.5, height: sphereSize * 2, length: self.nodeSize.width / 4, chamferRadius: 0.0))
		centreBlock.position.x = -Float(self.nodeSize.width) / 4
		let sideBlock = SCNNode(geometry: SCNBox(width: self.nodeSize.width / 1.5, height: sphereSize * 2, length: self.nodeSize.width / 4, chamferRadius: 0.0))
		sideBlock.position = SCNVector3(self.nodeSize.width / 4, 0.0, self.nodeSize.height / 3)
		let interiors: [SCNNode] = [centreBlock, sideBlock]
		interiors.forEach { (block) in
			block.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: nil)
			block.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "wood")
			block.position.y = Float(sphereSize)
			self.addChildNode(block)
		}
	}
	public func addBall(to position: SCNVector3? = nil) {
		let newBall = MarbleSphere(radius: self.sphereSize)
		if position != nil {
			newBall.position = position!
		}
		self.addChildNode(newBall)
		self.ballNodes.append(newBall)
		self.activeSphere = newBall
	}
}
