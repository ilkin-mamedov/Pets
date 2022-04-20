import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let userPickedImage = info[.editedImage] as? UIImage {
                imageView.image = userPickedImage
                
                guard let ciimage = CIImage(image: userPickedImage) else {
                    fatalError()
                }
                
                detect(ciimage)
            }
            
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
        func detect(_ image: CIImage) {
            guard let model = try? VNCoreMLModel(for: PetClassifier(configuration: .init()).model) else {
                fatalError()
            }
            
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else {
                    fatalError()
                }
                
                if let firstResult = results.first {
                    let title = firstResult.identifier.capitalized
                    
                    self.titleLabel.text = "It is \(title)"
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: image)
            
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
        }
}
