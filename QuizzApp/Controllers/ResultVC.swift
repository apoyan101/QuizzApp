//
//  ResultVC.swift
//  QuizzApp
//
//  Created by Ara Apoyan on 9/2/20.
//  Copyright © 2020 Ara Apoyan. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var dismissBtn: UIButton!
    
    var resultText = ""
    var feedBackText = ""
    var dismissButtonText = ""
    
    var incrementDelegate: Increment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round the dialog box corners
        dialogView.layer.cornerRadius = 15
    }
    
    // MARK: -  Set Up UI Elements Method
    func setUpUI() {
        
        // Implemenets the texts
        self.resultLabel.text = resultText
        self.feedbackLabel.text = feedBackText
        self.dismissBtn.setTitle(dismissButtonText, for: .normal)
        
        // Change text color by answer
        if resultLabel?.text == "Correct!" {
            resultLabel?.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        } else if resultLabel?.text == "Wrong!"  {
            resultLabel?.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            resultLabel?.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        }
    }
    
    // MARK: - View Will Appear Method
    override func viewWillAppear(_ animated: Bool) {
        
        // Set up UI elementes
        setUpUI()
        
        // Hide the UI elements for the animation
        self.dimView.alpha = 0
        self.resultLabel.alpha = 0
        self.feedbackLabel.alpha = 0
    }
    
    // MARK: - View Did Appear Method
    override func viewDidAppear(_ animated: Bool) {
        
        // Fade in the UI elements
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.dimView.alpha = 1
            self.resultLabel.alpha = 1
            self.feedbackLabel.alpha = 1
        }, completion: nil)
    }
    
    // MARK: - IBA Action Methods
    @IBAction func dismissBtnWasTapped(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            self.dimView.alpha = 0
        }) { (completed) in
            // Dismiss the popup window
            self.dismiss(animated: true, completion: nil)
            
            // Notify the delegate method
            self.incrementDelegate?.increment()
        }
    }
    
}
