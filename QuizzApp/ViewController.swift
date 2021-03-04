//
//  ViewController.swift
//  QuizzApp
//
//  Created by Ara Apoyan on 9/1/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.
//

import UIKit

class MainVC: UIViewController, QuizProtocol, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tabelView: UITableView!
    
    var model = QuizModel()
    var questions: [Question] = []
    var currentQuestionIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set self as the delegate and dataSource for tableview
        tabelView.delegate = self
        tabelView.dataSource = self
        
        // Set up model
        model.delegate = self
        model.getQuestions()
    }
    
    func displayQuestion() {
        
        // Check if there are questions and check that qurrentQuestionIndex is not out of boinds
        guard questions.count > 0 && currentQuestionIndex < questions.count else {
            return
        }
        
        // Display the question text
        questionLabel.text = questions[currentQuestionIndex].question
        
        // Reload the tableView
        self.tabelView.reloadData()
    }
    
    // MARK: - QuizProtocol Methods
    func questionRetrieved(_ questions: [Question]) {
        
        // Get the references to the questions
        self.questions = questions
        
        // Display the first question
        displayQuestion()
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Make sure that the questions array contains at least a question
        guard questions.count > 0 else  {
            return 0
        }
        
        // Return the number of answers of the questions
       let currentQuestion = questions[currentQuestionIndex]
        
        if currentQuestion.answers != nil {
            return currentQuestion.answers!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        // Customize it
        if let label = cell.viewWithTag(1) as? UILabel {
            
            // Set the answer text for the label
            let question = questions[currentQuestionIndex]
            if question.answers != nil {
                label.text = question.answers![indexPath.row]
            }
        }
        
        // Return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // User has tapped on a row, check if it's the rigth answer
        let question = questions[currentQuestionIndex]
        
        if question.correctAnswerIndex == indexPath.row {
            
            // The user got it right
            print("asder")
        } else {
            
            // The user got it wrog
        }
        
        // Increment the currentQuestionIndex
        currentQuestionIndex += 1
        
        // Display the next question
        displayQuestion()
    }
    
}

