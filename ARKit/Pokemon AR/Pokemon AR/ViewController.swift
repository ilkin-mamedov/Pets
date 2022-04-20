import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        if let trackImages = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            configuration.trackingImages = trackImages
            configuration.maximumNumberOfTrackedImages = 2
        }
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        DispatchQueue.main.async {
            if let imageAnchor = anchor as? ARImageAnchor {
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                                     height: imageAnchor.referenceImage.physicalSize.height)
                let planeNode = SCNNode(geometry: plane)
                
                plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
                planeNode.eulerAngles.x = -.pi / 2
                node.addChildNode(planeNode)
                
                let pokemon = imageAnchor.referenceImage.name!
                
                if let pokeScene = SCNScene(named: "art.scnassets/\(pokemon).scn") {
                    if let pokeNode = pokeScene.rootNode.childNodes.first {
                        pokeNode.eulerAngles.x = .pi / 2
                        planeNode.addChildNode(pokeNode)
                    }
                }
            }
        }
        
        return node
    }
}
