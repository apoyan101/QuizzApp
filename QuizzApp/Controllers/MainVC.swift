//
//  ViewController.swift
//  QuizzApp
//
//  Created by Ara Apoyan on 9/1/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.
//

import UIKit


class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, QuizProtocol, Increment {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    
    var model = QuizModel()
    
    var questions: [Question] = []
    var currentQuestionIndex: Int = 0
    var correctAnswer: Int = 0
    
    var resultVC: ResultVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the result view controller
        if let vc = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultVC {
            resultVC = vc
            resultVC!.modalPresentationStyle = .overCurrentContext
            resultVC?.incrementDelegate = self
        }
        
        // Set self as the delegate and dataSource for tableview
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Dynamic row heights
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        
        // Set up model
        self.model.delegate = self
        self.model.getQuestions()
    }
    
    // MARK: - Display the question Method
    func displayQuestion() {
        
        // Check if there are questions and check that qurrentQuestionIndex is not out of range
        guard questions.count > 0 && currentQuestionIndex < questions.count else { return }
        
        // Display the current question text
        self.questionLabel.text = questions[currentQuestionIndex].question
        
        // Reload the answers table
        self.tableView.reloadData()
    }
    
    // MARK: - QuizProtocol Methods
    func questionRetrieved(_ questions: [Question]) {
        
        // Get the references to the questions
        self.questions = questions
        
        // Set the data
        let saveIndexOfQurrentQusetion = StateManager.retrieveTheValue(key: StateManager.currentQuestionIndexKey) as? Int
        let saveNumberOfCorrAnswer = StateManager.retrieveTheValue(key: StateManager.numberOfCorrectAnswerKey) as? Int
        
        // Check if saveIndexOfQurrentQusetion is not nil and not out of range of questions
        if saveIndexOfQurrentQusetion != nil && saveIndexOfQurrentQusetion! < self.questions.count {
            // Set the current question index to saved index
            self.currentQuestionIndex = saveIndexOfQurrentQusetion!
        }
        
        //  check if saveNumberOfCorrAnswer is not nil
        if saveNumberOfCorrAnswer != nil {
            // Set correctAnserCount to saved number of correct answer
            self.correctAnswer = saveNumberOfCorrAnswer!
        }
        
        // Display the question text
        displayQuestion()
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Make sure that the questions array contains at least a question
        guard questions.count > 0 else  { return 0 }
        
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
            // Get the current question
            let question = questions[currentQuestionIndex]
            
            // Check if current question has answers
            if question.answers != nil {
                // Set the anser text for the label
                label.text = question.answers![indexPath.row]
            }
        }
        
        // Return the cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Title for the answer
        var titleText = ""
        
        // User has tapped on a row, check if it's the rigth answer
        guard currentQuestionIndex < questions.count else { return }
        let question = questions[currentQuestionIndex]
        
        if question.correctAnswerIndex == indexPath.row {
            // The user got it right
            titleText = "Correct!"
            
            // Increment correct answer count 
            correctAnswer += 1
        } else {
            // The user got it wrong
            titleText = "Wrong!"
        }
        
        // Slide out the question
        slideOutQuestion()
        
        // Show the popup and initialize the result Dialog
        if resultVC != nil {
            // Customize the dialog text
            resultVC!.resultText = titleText
            resultVC!.feedBackText = question.feedback!
            resultVC!.dismissButtonText = "Next"
            
            // Present the view controller
            DispatchQueue.main.async {
                self.present(self.resultVC!, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Increment Protocol method
    func increment() {
        
        // Increment the currentQuestionIndex
        self.currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            // The user has just answered the last question
            
            // Show the summary Dialog
            if resultVC != nil {
                resultVC!.resultText = "Summary"
                resultVC!.feedBackText = "You got \(correctAnswer) correct answers out of \(questions.count) questions."
                resultVC!.dismissButtonText = "Restart"
                
                // Present the view controller
                DispatchQueue.main.async {
                    self.present(self.resultVC!, animated: true, completion: nil)
                }
                
                // Clear the saved states
                StateManager.clearState()
            }
        } else if currentQuestionIndex < questions.count {
            // We have questions to show
            
            // Display the next question
            displayQuestion()
            
            // Save the state
            StateManager.saveData(numberOfCorrectAnswer: correctAnswer, currentQuestionIndex: currentQuestionIndex)
        } else if currentQuestionIndex > questions.count {
            // Reset the quiz
            currentQuestionIndex = 0
            correctAnswer = 0
            
            // Display the next question
            displayQuestion()
        }
        // Slide in the question
        slideInQuestion()
    }
    
    // MARK: - Slide Out and Slide In question animation Methods
    func slideOutQuestion() {
        
        // Set the initial state
        self.stackViewLeadingConstraint.constant = 0
        self.stackViewTrailingConstraint.constant = 0
        self.rootStackView.alpha = 1
        self.view.layoutIfNeeded()
        
        // Animate it to the end and state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.stackViewLeadingConstraint.constant = -1000
            self.stackViewTrailingConstraint.constant = 1000
            self.rootStackView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func slideInQuestion() {
        
        // Set the initial state
        self.stackViewLeadingConstraint.constant = 1000
        self.stackViewTrailingConstraint.constant = -1000
        self.rootStackView.alpha = 0
        self.view.layoutIfNeeded()
        
        // Animate it to the end and state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.stackViewLeadingConstraint.constant = 0
            self.stackViewTrailingConstraint.constant = 0
            self.rootStackView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
}
