//
//  ClassifierVF.swift
//  FreshApp
//
//  Created by aluno-05 on 01/09/25.
//

import Foundation
import SwiftData


@Model
final class ClassifierVF: Identifiable {
    var id = UUID()
    var imageData: Data?
    var nameFruit: String
}
