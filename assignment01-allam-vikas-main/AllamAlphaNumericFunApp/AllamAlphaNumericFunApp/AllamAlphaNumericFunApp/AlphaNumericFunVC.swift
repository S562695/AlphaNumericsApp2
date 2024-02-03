//
//  AlphaNumericFunVC.swift
//  AllamAlphaNumericFunApp
//
//  Created by vikas allam on 1/31/24.
//
import UIKit
import AudioToolbox
import AnimatedGradientView
import Lottie

class AlphaNumericFunVC: UIViewController {
    
    @IBOutlet weak var launchLAV: LottieAnimationView!
    {
        didSet {
            launchLAV.animation = .named("welcome_animation")
            launchLAV.alpha = 1    //alpha value modified
            launchLAV.play { [weak self] _ in
                UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1,
                delay: 0.0,
                options: [.curveEaseInOut]
            ){
                self?.launchLAV.alpha = 0.0
            }}
        }
    }
    @IBOutlet weak var StringsSV: UIStackView!
    @IBOutlet weak var categorySC: UISegmentedControl!
    @IBOutlet weak var outputResetSV: UIStackView!
    @IBOutlet weak var headerSV: UIStackView!
    @IBOutlet weak var numbersSV: UIStackView!
    @IBOutlet weak var inputStringTF: UITextField!
    @IBOutlet weak var firstNumberLBL: UILabel!
    @IBOutlet weak var lowercaseSWCH: UISwitch!
    @IBOutlet weak var secondNumberStepper: UIStepper!
    @IBOutlet weak var firstNumberStepper: UIStepper!
    @IBOutlet weak var outputTV: UITextView!
    @IBOutlet weak var secondNumberLBL: UILabel!
    @IBOutlet weak var uppercaseSWCH: UISwitch!
    @IBOutlet weak var headerLBL: UILabel!
    
    @IBAction func uppercaseSWCH(_ sender: Any) {
    }
    
    @IBAction func lowercaseSWCH(_ sender: Any) {
    }
    
    
    var inputStringOrg: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        inputStringOrg = inputStringTF.text ?? ""
        let animatedGradient = AnimatedGradientView(frame: view.bounds)
        animatedGradient.direction = .up
        animatedGradient.animationValues = [(colors: ["#2BCOE4", "#EAECC6"], .up, .axial),
                                            (colors: ["#833ab4", "#fd1d1d", "fcb045"], .right, .axial),
                                            (colors: ["#003973", "#E6E68E"], .down, .axial),
                                            (colors: ["#1E9600", "#FFF200", "FF0000"], .left, .axial)]
        view.insertSubview(animatedGradient, at: 0)
        /*let animGradColor = CAGradientLayer()
            animGradColor.frame = view.bounds
            animGradColor.colors = [UIColor.white.cgColor, UIColor.systemGray.cgColor]
            view.layer.insertSublayer(animGradColor, at: 0)*/
        
        outputTV.text = "Welcome!\n\nInteract with the UI elements and have some fun with numbers and strings, and patterns that are generated using them."
        self.headerLBL.text = String(format: "%@\nHAVE SOME FUN", "\u{0C38}\u{0C2D}\u{0C15}\u{0C41} \u{0C28}\u{0C2E}\u{0C38}\u{0C4D}\u{0C15}\u{0C3E}\u{0C30}\u{0C02}")
        
        firstNumberStepper.addTarget(self, action: #selector(changedFirstNumStepper), for: .valueChanged)
        secondNumberStepper.addTarget(self, action: #selector(changedSecondNumberStepper), for: .valueChanged)
        inputStringTF.addTarget(self, action: #selector(inputStrg), for: .editingChanged)
        resettingUIElements()
        setStackViewStyle(headerSV)
        setStackViewStyle(numbersSV)
        setStackViewStyle(StringsSV)
        setStackViewStyle(outputResetSV)
        // Do any additional setup after loading the view.
        
    }
    private func setStackViewStyle(_ stackView: UIStackView) {
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 5
        stackView.layer.masksToBounds = true
    }
    
    private func resettingUIElements() {
        if categorySC.selectedSegmentIndex != 1 { inputStringTF.isEnabled = false }
        lowercaseSWCH.isEnabled = false
        uppercaseSWCH.isEnabled = false
        outputTV.isEditable = false
        categorySC.isEnabled = true
    }
    
    
    @IBAction func reset(_ sender: Any) {
        resettingUIElements()
        outputTV.text = "Welcome!\n\nInteract with the UI elements and have some fun with numbers and strings, and patterns that are generated using them."
        firstNumberLBL.text = "0"
        secondNumberLBL.text = "0"
        firstNumberStepper.value = 0
        secondNumberStepper.value = 0
        inputStringTF.text = ""
        
        
    }
    @IBAction func updateSecondNumber(_ sender: Any) {
        AudioServicesPlaySystemSound(1103)
        patternModification()
        displayPatternInstructions()
    }
    @IBAction func lowercaseString(_ sender: Any) {
        if lowercaseSWCH.isOn {
                uppercaseSWCH.setOn(false, animated: true)
                inputStringTF.text = inputStringTF.text?.lowercased()
            } else if !uppercaseSWCH.isOn {
                inputStringTF.text = inputStringOrg
            }
            updString()
    }
    @IBAction func updateFirstNumber(_ sender: Any) {
        AudioServicesPlaySystemSound(1103)
        displayPatternInstructions()
        patternModification()
        
    }
    @IBAction func selectCategory(_ sender: Any) {
        AudioServicesPlaySystemSound(1104)
        resettingUIElements()
        switch categorySC.selectedSegmentIndex {
        case 0:
            numberCreation()
            numberDisplay()
        case 1:
            stringCreation()
            stringDisplay()
        case 2:
            enablePatternUIElements()
            displayPatternInstructions()
        default:
            break
        }
    }

    func enablePatternUIElements() {
        firstNumberStepper.isEnabled = true
        secondNumberStepper.isEnabled = true
    }

    func displayPatternInstructions() {
        guard categorySC.selectedSegmentIndex == 2 else {
                return
        }
        let firstNum = Int(firstNumberStepper.value)
        let ssecondNum = Int(secondNumberStepper.value)
            outputTV.text = ""
        if firstNum == 0 {
            outputTV.text += "Use the 1st number stepper to increment the number value.\n\n"
        } else{
            outputTV.text += "Use the 2nd number stepper to increment the number value.\n\n"
        }
        let rowVal = Int(firstNumberStepper.value)
        let colVal = Int(secondNumberStepper.value)
        for row in 0..<rowVal {
            for column in 0..<colVal {
                if row == 0 || row == rowVal - 1 || column == 0 || column == colVal - 1 {
                    outputTV.text += "⭐"
                } else {
                        let evenCheck = (row + column) % 2 == 0
                        let emojiCheck: String = evenCheck ? "◼️" : "◻️"
                        outputTV.text += emojiCheck
                    }
                }
                outputTV.text += "\n"
            }
        }
    func patternModification() {
        let rowVal = Int(firstNumberStepper.value)
        let colVal = Int(secondNumberStepper.value)
        firstNumberLBL.text = "\(rowVal)"
        secondNumberLBL.text = "\(colVal)"
    }
    func stringCreation() {
        inputStringTF.isEnabled = true
        lowercaseSWCH.isEnabled = true
        uppercaseSWCH.isEnabled = true
        firstNumberStepper.isEnabled = false
        secondNumberStepper.isEnabled = false
    }
    func numberCreation() {
        firstNumberStepper.isEnabled = true
        secondNumberStepper.isEnabled = true
    }
    func numberDisplay() {
        guard categorySC.selectedSegmentIndex == 0 else {
                return
        }
        let firstnum = Int(firstNumberStepper.value)
        let secondNum = Int(secondNumberStepper.value)
        firstNumberLBL.text = "\(firstnum)"
        secondNumberLBL.text = "\(secondNum)"
        outputTV.text = ""
        
        if( firstnum >= 1 && secondNum >= 1) {
            let sqNumber = firstnum * firstnum
            let sqNumber2 = secondNum * secondNum
            let cubeNumber = firstnum * firstnum * firstnum
            let cubeNumber2 = secondNum * secondNum * secondNum
            let binaryrep = String(firstnum, radix: 2)
            let binaryrep2 = String(secondNum, radix: 2)
            let concatRep = "\(firstnum)\(secondNum)"
            outputTV.text = "Concatenation of two numbers is \"\(concatRep)\"\n\n"
            outputTV.text += """
                    Square and Cube of \(firstnum) are \(sqNumber) and \(cubeNumber), respectively.
                    Square and Cube of \(secondNum) are \(sqNumber2) and \(cubeNumber2), respectively.
                    Binary representation of \(firstnum) is \(binaryrep).
                    Binary representation of \(secondNum) is \(binaryrep2).
                    \n
                    """
        } else if firstnum == 0 {
            outputTV.text += "Use the 1st number stepper to increment the number value.\n\n"
        } else{
            outputTV.text += "Use the 2nd number stepper to increment the number value.\n\n"
        }
    }
    
    func stringDisplay() {
        guard let inputString = inputStringTF.text, !inputString.isEmpty else {
            outputTV.text = "Please provide at least one character."
            return
        }
        
        outputTV.text = "\(inputString)\n\n"
        
        if lowercaseSWCH.isOn {
            inputStringTF.text = inputString.lowercased()
        } else if uppercaseSWCH.isOn {
            inputStringTF.text = inputString.uppercased()
        }
        let palindromeChecker = inputString == String(inputString.reversed())
        let vowelVal = inputString.lowercased().filter { "aeiou".contains($0) }
        let consonantVal = inputString.lowercased().filter { "bcdfghjklmnpqrstvwxyz".contains($0) }
        let uniqueVal = Set(inputString).count
        
        outputTV.text += """
        Given String "\(inputString)" is \(palindromeChecker ? "a" : "not a") Palindrome.
        Count of vowels in "\(inputString)" is \(vowelVal.count).
        Count of consonants in "\(inputString)" is \(consonantVal.count).
        Count of unique characters in "\(inputString)" is \(uniqueVal).
        The reversal of "\(inputString)" results in "\(String(inputString.reversed()))".
        """
    }
    @objc func changedFirstNumStepper() {
        numberDisplay()
    }
    
    @objc func changedSecondNumberStepper() {
        numberDisplay()
    }
    
    @objc func inputStrg() {
        updString()
    }
    private func updString() {
        if categorySC.selectedSegmentIndex == 1 {
            stringDisplay()
        }
    }

    @IBAction func uppercaseString(_ sender: Any) {
        if uppercaseSWCH.isOn {
                lowercaseSWCH.setOn(false, animated: true)
                inputStringTF.text = inputStringTF.text?.uppercased()
            } else if !lowercaseSWCH.isOn {
                inputStringTF.text = inputStringOrg
            }
            updString()
        }
    
    @IBAction func respondToValueChange(_ sender: Any) {
        
    }
    
    /*
     Bonus:
     
     Here are possible answers for the bonus questions in the assignment:

     1. The main attributes in Auto Layout are frame, bounds, center, leading/trailing edges, top/bottom edges, width, height, and baseline. These attributes define the size, position and spacing of views, allowing constraints to be created between them.

     2. Stack views automatically manage the layout of their arranged subviews by applying constraints between them. This eliminates the need to manually define those constraints, greatly simplifying layout code. Stack views have settings for orientation, alignment, distribution and spacing that further adjust subview layout.

     3. Control-dragging between two views creates a constraint between them based on where you drag from/to. For example, dragging from one view's leading edge to another view's leading edge pins those edges together. This provides a quick way to visually build constraints.

     4. The Auto Layout tools in Interface Builder provide a simple way to modify constraints, align views, pin edges, or fix issues. For example, the Align tool aligns views to each other along an axis, the Pin tool adds constraints to pin edges to superview bounds, and the Resolve Auto Layout Issues tool fixes conflicts. These streamline building a properly constrained layout.
     */
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
