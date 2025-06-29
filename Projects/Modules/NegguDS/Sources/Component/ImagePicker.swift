//
//  ImagePicker.swift
//  neggu
//
//  Created by 유지호 on 2/21/25.
//

import SwiftUI
import AVFoundation

public struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isActive: Bool
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    public init(image: Binding<UIImage?>, isActive: Binding<Bool>) {
        self._image = image
        self._isActive = isActive
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        
        // TODO: 추후 커스텀
//        picker.allowsEditing = true
        picker.delegate = context.coordinator
        
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, isActive: $isActive)
    }
    
    public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        @Binding var image: UIImage?
        @Binding var isActive: Bool
        
        init(image: Binding<UIImage?>, isActive: Binding<Bool>) {
            _image = image
            _isActive = isActive
        }
        
        public func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image = uiImage
                isActive = false
            }
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isActive = false
        }
    }
}
