//
//  FilterViewController.swift
//  ImageFilter
//
//  Created by Park Kangwook on 2022/08/30.
//

import UIKit

class FilterViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    let imageArea: UILabel = {
        let label = UILabel()
        label.text = "사진 선택"
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    let selectedImage: UIImageView = {
        let iv = UIImageView()
//        iv.image = UIImage(named:"")
        iv.isUserInteractionEnabled = true
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
            
        return iv
    }()
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        
        
        view.addSubview(imageArea)
        imageArea.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageArea.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageArea.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            imageArea.widthAnchor.constraint(equalToConstant: 100),
            imageArea.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // MARK: - 카메라 켜기
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageArea.isUserInteractionEnabled = true
        imageArea.addGestureRecognizer(tapGestureRecognizer)
        
        // MARK: - 사진 띄우기
        if selectedImage.image?.size.height != 0 {
            view.addSubview(selectedImage)
            selectedImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                selectedImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                selectedImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                selectedImage.widthAnchor.constraint(equalTo: view.widthAnchor),
                selectedImage.heightAnchor.constraint(equalTo: view.widthAnchor)
            ])
            
            selectedImage.layer.cornerRadius = 40
            selectedImage.clipsToBounds = true
        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
                
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage.image = imagePicked
            print("Image picked height:", imagePicked.size.height, "Image picked width:", imagePicked.size.width)
        }
        
        imagePicker.dismiss(animated: true) {
            print("Picker Dismissed...")
        }

    }
    
}
