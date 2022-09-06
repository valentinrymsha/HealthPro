//
//  StepWidgetModel.swift
//  HealthPro
//
//  Created by User on 9/6/22.
//

import Foundation

struct StepWidgetModel: Identifiable {
    let id = UUID()
    let imageNumber: Int
    let imageName: String
}

extension StepWidgetModel {
    static var sample = [
    StepWidgetModel(imageNumber: 1, imageName: "Tomato"),
    StepWidgetModel(imageNumber: 2, imageName: "Potato"),
    StepWidgetModel(imageNumber: 3, imageName: "Pizza")
    ]
}
