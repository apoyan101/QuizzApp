//
//  Question.swift
//  QuizzApp
//
//  Created by Ara Apoyan on 9/1/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.
//

import Foundation

struct Question: Codable {
    var question: String?
    var answers: [String]?
    var correctAnswerIndex: Int?
    var feedback: String?
}
