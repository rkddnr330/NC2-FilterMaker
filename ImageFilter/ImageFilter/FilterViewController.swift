//
//  FilterViewController.swift
//  ImageFilter
//
//  Created by Park Kangwook on 2022/08/30.
//

import UIKit
import Vision

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
    
    let button: UILabel = {
        let label = UILabel()
        label.text = "필터 적용"
        label.backgroundColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        
        // MARK: - 사진 선택
        imageArea.textColor = .black
        view.addSubview(imageArea)
        imageArea.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageArea.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            imageArea.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            imageArea.widthAnchor.constraint(equalToConstant: 100),
            imageArea.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // MARK: - 핕터 적용
//        view.addSubview(button)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
//            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
//            button.widthAnchor.constraint(equalToConstant: 100),
//            button.heightAnchor.constraint(equalToConstant: 70)
//        ])
//
//        let goFilter = UITapGestureRecognizer(target: self, action: #selector(transformImage(tapGestureRecognizer:)))
//        imageArea.isUserInteractionEnabled = true
//        imageArea.addGestureRecognizer(goFilter)
        
        
        let filterBtn = UIButton()
        //title
        filterBtn.setTitle("필터 적용", for: .normal)

        //title color
        filterBtn.setTitleColor(.black, for: .normal)

        //title fontsize
        filterBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)

        filterBtn.backgroundColor = .lightGray


        //imageview image size
        filterBtn.setPreferredSymbolConfiguration(.init(pointSize: 3, weight: .regular, scale: .default), forImageIn: .normal)

        //imageview image color
        filterBtn.tintColor = .black

        //UIButton insets
//        filterBtn.titleEdgeInsets = .init(top: .zero, left: 8, bottom: .zero, right: .zero)

        //UIButton add action
        filterBtn.addTarget(self, action: #selector(transformImage), for: .touchUpInside)
        
        view.addSubview(filterBtn)
        
        filterBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            filterBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filterBtn.widthAnchor.constraint(equalToConstant: 100),
            filterBtn.heightAnchor.constraint(equalToConstant: 70)
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
    
    @objc func transformImage() {
        print("필터 버튼 탭")
        // Style Transfer Here
        let model = Gogh()
//        let styleArray = try? MLMultiArray(shape: [1] as [NSNumber], dataType: .double)
//        styleArray?[0] = 1.0
//        print(styleArray)
        
        if let image = pixelBuffer(from: selectedImage.image!) {
            do {
                let predictionOutput = try model.prediction(image: image)
                        
                let ciImage = CIImage(cvPixelBuffer: predictionOutput.stylizedImage)
                let tempContext = CIContext(options: nil)
                let tempImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(predictionOutput.stylizedImage), height: CVPixelBufferGetHeight(predictionOutput.stylizedImage)))
                selectedImage.image = UIImage(cgImage: tempImage!)
            } catch let error as NSError {
                print("CoreML Model Error: \(error)")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage.image = imagePicked
            guard let ciimage = CIImage(image: imagePicked) else {
                fatalError("Converting UIImage to CIImage Failed")
            }
            
            
        }
        
        imagePicker.dismiss(animated: true) {
            print("Picker Dismissed...")
        }

    }
    
}

// MARK: - ML 코드 작성

extension FilterViewController {


    func pixelBuffer(from image: UIImage) -> CVPixelBuffer? {
        // 1. Since our model only accepts images with dimensions of 256 x 256, we convert the image into a square. Then, we assign the square image to another constant newImage.
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 512, height: 512))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
     
        // 2. Now, we convert newImage into a CVPixelBuffer. If you’re not familiar with CVPixelBuffer, it’s basically an image buffer which holds the pixels in the main memory. You can find out more about CVPixelBuffers here.
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, 512, 512, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
           
        // 3. We then take all the pixels present in the image and convert them into a device-dependent RGB color space. Then, by creating all this data into a CGContext, we can easily call it whenever we need to render (or change) some of its underlying properties. This is what we do in the next two lines of code by translating and scaling the image.

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
           
        // 4. Finally, we make the graphics context into the current context, render the image, and remove the context from the top stack. With all these changes made, we return our pixel buffer.

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: 512, height: 512, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
           
        // 5
        context?.translateBy(x: 0, y: 512)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 6
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: 512, height: 512))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
            
        return pixelBuffer
    }
}