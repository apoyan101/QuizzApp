//
//  StateManager.swift
//  QuizzApp
//
//  Created by Ara Apoyan on 9/3/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.
//

import Foundation

class StateManager {
    
    static let numberOfCorrectAnswerKey = "numberOfCorrectAnswerKey"
    static let currentQuestionIndexKey = "currentQuestionIndexKey"
    
    static func saveData(numberOfCorrectAnswer: Int, currentQuestionIndex: Int) {
        
        // Get the reference to user defaults and save the data
        UserDefaults.standard.set(numberOfCorrectAnswer, forKey: numberOfCorrectAnswerKey)
        UserDefaults.standard.set(currentQuestionIndex, forKey: currentQuestionIndexKey)
    }
    
    static func retrieveTheValue(key: String) -> Any? {
        
        // Get the reference to user defaults and set it
        return UserDefaults.standard.value(forKeyPath: key)
    }
    
    static func clearState() {
        
        // Get the reference to user defaults and clear the state data from the user defaults
        UserDefaults.standard.removeObject(forKey: numberOfCorrectAnswerKey)
        UserDefaults.standard.removeObject(forKey: currentQuestionIndexKey)
    }
    
}
