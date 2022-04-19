import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    private var dicee = [SCNNode]()

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
     
    private func addDice(at location: ARRaycastResult) {
        let scene = SCNScene(named: "art.scnassets/dice.scn")!

        if let dice = scene.rootNode.childNode(withName: "Dice", recursively: true) {
            dice.position = SCNVector3(
                location.worldTransform.columns.3.x,
                location.worldTransform.columns.3.y + dice.boundingSphere.radius,
                location.worldTransform.columns.3.z
            )
            
            dicee.append(dice)
            sceneView.scene.rootNode.addChildNode(dice)
            roll(dice)
        }
    }
    
    private func roll(_ dice: SCNNode) {
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        
        dice.runAction(SCNAction.rotateBy(
            x: CGFloat(randomX * 3),
            y: 0,
            z: CGFloat(randomZ * 3),
            duration: 0.5))
    }
    
    private func rollAll() {
        if !dicee.isEmpty {
            for dice in dicee {
                roll(dice)
            }
        }
    }
    
    @IBAction func rollPressed(_ sender: UIButton) {
        rollAll()
    }
    
    @IBAction func removePressed(_ sender: UIButton) {
        if !dicee.isEmpty {
            for dice in dicee {
                dice.removeFromParentNode()
            }
        }
    }
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            
            guard let query = sceneView.raycastQuery(from: location, allowing: .existingPlaneInfinite, alignment: .any) else {
               return
            }
                    
            let results = sceneView.session.raycast(query)
            
            if let hitResult = results.first {
                addDice(at: hitResult)
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let planeNode = createPlane(with: planeAnchor)

        node.addChildNode(planeNode)
    }
    
    private func createPlane(with planeAnchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let node = SCNNode()

        node.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        node.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)

        let grid = SCNMaterial()

        grid.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.materials = [grid]
        node.geometry = plane
        
        return node
    }
}
