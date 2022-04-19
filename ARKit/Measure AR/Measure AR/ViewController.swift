import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    private var points = [SCNNode]()
    private var text = SCNNode()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        sceneView.debugOptions = [.showFeaturePoints]
    }
    
    private func calculate() {
        let start = points[0]
        let end = points[1]
        
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )
        
        updateText(string: "\(String(format: "%.1f", abs(distance) * 100)) cm",
            at: end.position)
    }
    
    private func updateText(string: String, at: SCNVector3) {
        text.removeFromParentNode()
        
        let textGeometry = SCNText(string: string, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white
        
        text = SCNNode(geometry: textGeometry)
        
        text.position = SCNVector3(at.x, at.y, at.z)
        text.scale = SCNVector3(0.005, 0.005, 0.005)
        
        sceneView.scene.rootNode.addChildNode(text)
    }
}

//MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    
    @available(iOS, deprecated: 14.0)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if points.count >= 2 {
            for point in points {
                point.removeFromParentNode()
            }
            points = [SCNNode]()
        }
        
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(location, types: .featurePoint)
            
            if let result = results.first {
                addPoint(at: result)
            }
        }
    }
    
    @available(iOS, deprecated: 14.0)
    private func addPoint(at result: ARHitTestResult) {
        let sphere = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.white
        sphere.materials = [material]
        
        let point = SCNNode(geometry: sphere)
        
        point.position = SCNVector3(
            CGFloat(result.worldTransform.columns.3.x),
            CGFloat(result.worldTransform.columns.3.y),
            CGFloat(result.worldTransform.columns.3.z)
        )
        
        sceneView.scene.rootNode.addChildNode(point)
        points.append(point)
        
        if points.count >= 2 {
            calculate()
        }
    }
}
