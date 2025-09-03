//
//  Untitled.swift
//  FreshApp
//
//  Created by aluno-05 on 02/09/25.
//

import UIKit
import Vision
import CoreML
import ImageIO

struct ClassPrediction {
    let classId: String          // ex.:paste "strawberryFresh"
    let confidence: Float
    let topK: [(id: String, confidence: Float)]
    var parsed: (fruit: String, freshness: String) {
        let raw = classId.replacingOccurrences(of: "_", with: "").lowercased()
        let freshness = raw.hasSuffix("rotten") ? "rotten" : "fresh"
        var fruit = raw
        if fruit.hasSuffix("rotten") { fruit.removeLast("rotten".count) }
        else if fruit.hasSuffix("fresh") { fruit.removeLast("fresh".count) }
        return (fruit, freshness)
    }
}

final class ProduceClassifier {
    static let shared = ProduceClassifier()

    private let vnModel: VNCoreMLModel

    private init?() {
        guard let core = try? FruitAndVegetableClassifier(configuration: .init()).model,
              let vn = try? VNCoreMLModel(for: core) else { return nil }
        self.vnModel = vn
    }

    func classify(_ image: UIImage, topK k: Int = 5) async throws -> ClassPrediction {
        let cg = try image.fixedCGImage()
        let handler = VNImageRequestHandler(
            cgImage: cg,
            orientation: image.cgImageOrientation,
            options: [:]
        )

        let req = VNCoreMLRequest(model: vnModel)
        try handler.perform([req])

        guard let results = req.results as? [VNClassificationObservation],
              let best = results.first else {
            throw NSError(domain: "ProduceClassifier", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Sem resultados"])
        }

        let top = results.prefix(k).map { ($0.identifier, $0.confidence) }
        return ClassPrediction(classId: best.identifier,
                               confidence: best.confidence,
                               topK: Array(top))
    }
}

private extension UIImage {
    func fixedCGImage() throws -> CGImage {
        if let cg = self.cgImage, imageOrientation == .up { return cg }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cg = normalized?.cgImage else {
            throw NSError(domain: "ProduceClassifier", code: -2,
                          userInfo: [NSLocalizedDescriptionKey: "Falha ao normalizar imagem"])
        }
        return cg
    }
    var cgImageOrientation: CGImagePropertyOrientation {
        switch imageOrientation {
        case .up: return .up
        case .down: return .down
        case .left: return .left
        case .right: return .right
        case .upMirrored: return .upMirrored
        case .downMirrored: return .downMirrored
        case .leftMirrored: return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default: return .up
        }
    }
}
