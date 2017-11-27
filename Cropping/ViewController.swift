//
//  ViewController.swift
//  Cropping
//
//  Created by chen levi on 22.11.2017.
//  Copyright © 2017 chen levi. All rights reserved.
//

import UIKit
import FaceCropper


class ViewController: UIViewController {
    
    public var listener : (([UIImage]) -> Void)?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startAction(_ sender: Any) {
        let imageToCrop = imageView.image!
        imageToCrop.face.crop { result in
            switch result {
            case .success(let faces):
                // When the `Vision` successfully find faces, and `FaceCropper` cropped it.
            // `faces` argument is a collection of cropped images.
                print(faces)
                self.listener?(faces)
            case .notFound:
                print("not found")
            // When the image doesn't contain any face, `result` will be `.notFound`.
            case .failure(let error):
                print("fail",error)
                // When the any error occured, `result` will be `failure`.
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? CollectionViewController else{return}
        listener = dest.setData(passData:)
    }
    
    
    @IBAction func getAction(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
        
    }
    

}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        imageView.image = image
        
        dismiss(animated: true)

    }
}

