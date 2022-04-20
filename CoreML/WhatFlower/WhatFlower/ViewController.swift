import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    
    private let imagePicker = UIImagePickerController()
    
    private let url = "https://en.wikipedia.org/w/api.php"
    private var openURL = "https://en.wikipedia.org/wiki"
    
    var parameters : [String : String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts|pageimages|info",
        "exintro" : "",
        "explaintext" : "",
        "titles" : "",
        "redirects" : "1",
        "pithumbsize" : "500",
        "indexpageids" : "",
        "inprop" : "url",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeholderLabel.text = "Tap  the camera button\nto take a photo"
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
    }

    @IBAction func goPressed(_ sender: UIButton) {
        if let url = URL(string: openURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.originalImage] as? UIImage {
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError()
            }
            
            detect(ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(_ image: CIImage) {
        guard let model = try? VNCoreMLModel(for: FlowerClassifier(configuration: .init()).model) else {
            fatalError()
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results?.first as? VNClassificationObservation else {
                fatalError()
            }
            
            self.parameters["titles"] = result.identifier
            
            AF.request(self.url, parameters: self.parameters).response { response in
                let json: JSON = JSON(response.value as Any)
                
                let pageid = json["query"]["pageids"][0].stringValue
                let page = json["query"]["pages"][pageid]
                
                let imageURL = page["thumbnail"]["source"].stringValue
                let title = page["title"].stringValue
                let description = page["extract"].stringValue
                let pageURL = page["fullurl"].stringValue
                
                DispatchQueue.main.async {
                    self.placeholderLabel.isHidden = true
                    self.goButton.isHidden = false
                    self.imageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(ciImage: image))
                    self.titleLabel.text = title
                    self.descriptionLabel.text = self.getShortString(text: description)
                    self.openURL = pageURL
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    private func getShortString(text: String) -> String {
        if text.count >= 200 {
            return "\(text.substring(to: 200))..."
        } else {
            return text
        }
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
}
