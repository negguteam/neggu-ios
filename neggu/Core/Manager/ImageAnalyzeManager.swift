//
//  ImageAnalyzeManager.swift
//  neggu
//
//  Created by 유지호 on 9/5/24.
//

import VisionKit

@MainActor
struct ImageAnalyzeManager {
    let analyzer = ImageAnalyzer()
    let configuration = ImageAnalyzer.Configuration([.text, .machineReadableCode, .visualLookUp])
    
    let interaction = ImageAnalysisInteraction()
    
    static let shared = ImageAnalyzeManager()
    
    init() { }
    
    func segmentation(_ data: Data) async -> UIImage? {
        do {
            guard let image = UIImage(data: data) else {
                throw NSError(domain: "Fail to get UIImage", code: 1)
            }
            
            let analysis = try await analyzer.analyze(image, configuration: configuration)
            
            interaction.analysis = analysis
            interaction.preferredInteractionTypes = .imageSubject
            
            let subjects = await interaction.subjects
            
            #if DEBUG
            print(subjects)
            #endif
            
            let segmentedImage = try await subjects.first?.image
            print(segmentedImage?.size ?? .zero)
            return segmentedImage
        } catch {
            #if DEBUG
            print(error.localizedDescription)
            #endif
            
            return nil
        }
    }
}
