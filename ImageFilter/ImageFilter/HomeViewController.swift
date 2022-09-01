//
//  HomeViewController.swift
//  ImageFilter
//
//  Created by Park Kangwook on 2022/08/26.
//

import UIKit
import CoreML
import Vision

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let remarkText: UILabel = {
        let label = UILabel()
        label.text = "this is Image Filter Maker by K :)"
        return label
    }()
    
    let filterThumbnail: UIImageView = {
        let imageview = UIImageView()
        imageview.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        imageview.contentMode = . scaleAspectFill
        
        return imageview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray

        // MARK: - remarkText
        
        view.addSubview(remarkText)
        
        remarkText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            remarkText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            remarkText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
        
        // MARK: - filterThumbnail
        
        addThumbnailImage(of: "gogh")
        
        filterThumbnail.layer.cornerRadius = 40
        filterThumbnail.clipsToBounds = true
        
        view.addSubview(filterThumbnail)
        
        filterThumbnail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterThumbnail.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterThumbnail.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            filterThumbnail.widthAnchor.constraint(equalToConstant: 200),
            filterThumbnail.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        filterThumbnail.isUserInteractionEnabled = true
        filterThumbnail.addGestureRecognizer(tapGestureRecognizer)
        
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView

        print("tapped!")
//        present(imagePicker, animated: true, completion: nil)
        self.navigationController?.pushViewController(FilterViewController(), animated: true)
        
    }
    
    private func addThumbnailImage(of image: String) {
        filterThumbnail.image = UIImage(named: image)
    }
}

//extension HomeViewController {
//    func didSelect(image: UIImage?) {
//        self.imagePicker.image = image
//    }
//}
