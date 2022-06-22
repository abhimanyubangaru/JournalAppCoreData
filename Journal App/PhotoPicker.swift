//
//  PhotoPicker.swift
//  PhotoPicker-Beta
//
//  Created by Abhi B on 6/17/22.
//

import Foundation
import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var chosenImage: Image?
    @Binding var imageData : Data?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true 
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //dont need it rn
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
        
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
        let photoPicker : PhotoPicker
        
        init(photoPicker : PhotoPicker){
            self.photoPicker = photoPicker
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                guard let data = image.jpegData(compressionQuality: 0.1), let compressedImage = UIImage(data: data) else {
                    return
                }
                photoPicker.imageData = data
                photoPicker.chosenImage = Image(uiImage: compressedImage)
            } else {
                //return an error show in alert
            }
            picker.dismiss(animated: true)
        }
    }
}
