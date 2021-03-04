//
//  Protocols.swift
//  QuizzApp
//
//  Created by Ara Apoyan on 9/2/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.
//

import Foundation

protocol QuizProtocol {
    func questionRetrieved(_ questions: [Question])
}

protocol Increment {
    func increment()
}
