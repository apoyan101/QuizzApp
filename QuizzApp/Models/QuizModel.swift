//
//  QuizModel.swift
//  QuizzApp
//
//  Created by Ara Apoyan on 9/1/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.
//

import Foundation


class QuizModel {
    
    var delegate: QuizProtocol?
    
    func getQuestions() {
        
        // Fetch the questions by localy
        getLocalJsonFile()
        
        // Fetch the question by remote
        // getRemoteJsonFile()
    }
    
    func getLocalJsonFile() {
        
        // Get the path to josn file
        let url = Bundle.main.url(forResource: "QuestionData", withExtension: "json")
        
//        // Double check if the path isn't nill
//        guard path != nil else {
//            print("Couldn't find the json data file")
//            return
//        }
        
        // Create URl object from the path
//        let url = URL(fileURLWithPath: path!)
        
        do {
            // Get the data from the  url
            let data = try Data(contentsOf: url!)
            
            // Try to decode the data into objects
            let decoder = JSONDecoder()
            let array = try decoder.decode([Question].self, from: data)
            
            // Notify the delegate of the parsed objects
            delegate?.questionRetrieved(array)
        } catch {
            // Error: could not download the data at that url
            print(error)
        }
    }
    
    func getRemoteJsonFile() {
        
        // Get a URL object
        let urlString = "https://codewithchris.com/code/QuestionData.json"
        
        guard let url = URL(string: urlString) else {
            print("Could not create URL object")
            return
        }
        
        // Get a URL Session object
        let session = URLSession.shared
        
        // Get a data task object
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            // Check that there was not an error
            guard let data = data, error == nil else {
                print("Something went wrong")
                return
            }
            
            do {
                
                // Create a JSON Decoder object
                let decoder = JSONDecoder()
                
                // Parse the JSON
                let array = try decoder.decode([Question].self, from: data)
                
                //
                DispatchQueue.main.async {
                    // Notify the delegate
                    self.delegate?.questionRetrieved(array)
                }
            } catch {
                print("Could not parse JSON")
            }
        }
        
        // Call resume to data task
        dataTask.resume()
    }
    
}
