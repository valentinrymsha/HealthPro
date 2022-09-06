//
//  FAQViewController.swift
//  HealthPro
//
//  Created by User on 9/1/22.
//

import UIKit

final class FAQViewController: UIViewController {

    // swiftlint:disable force_cast
    
    // MARK: Outlets
    
    @IBOutlet private weak var faqTableView: UITableView!
    
    // MARK: Properties
    
    private let faqArray = [["Valeria is a good mentor?": "Exactly!"],
                    ["What about her collegue?": "Also brilliat!"],
                    ["How match api's the HealthPro uses?": "2 api's for diff goals."],
                    ["How i can logout from app?": "You can do it in the Setting's menu."],
                    ["Calculator do right?": "Yes, ofcource :)"],
                    ["Who is founder of HealthPro?": "Valentin Rymsha."],
                    ["How match account's i can to have?": "Eterniti <3"],
                    ["Whats up?": "Nice cock."],
                    ["Where localize servers of HealthPro?": "Republic of Belarus."],
                    ["How many users HealthPro have?": "Near 2m+ users."],
                    ["How i can create account?": "You can do it when you opening app at first."],
                    ["How i can delete account?": "You cant do it yet."],
                    ["How i can recive my password?": "You can do it with reciving on logining page."],
                    ["Will app enable withot internet?": "Yes, but with limitations."],
                    ["Can i recommend your app for friend?": "Absolutly yes."],
                    ["Whats time is it?": "Now a good time for sleeping"],
                    ["2 + 2?": "5."],
                    ["What is a age limit?": "Our application is for a people 0+."],
                    ["Do you like green color?": "Yes."]]
    
    private let faqStoryboard: UIStoryboard = UIStoryboard(name: "FAQ", bundle: nil)
    private var selectedIndex = Int()
    private var isCollapce = Bool()
    
    
    
    // MARK: Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        faqTableView.delegate = self
        faqTableView.dataSource = self
        faqTableView.rowHeight = UITableView.automaticDimension
        faqTableView.layer.cornerRadius = 13
    }

    
    // MARK: Actions
    
    
}

// MARK: UITableViewDatasource

extension FAQViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        faqArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell") as! FAQTableViewCell
                
        cell.questionLabel.text = faqArray[indexPath.row].keys.first
        cell.answerLabel.text = faqArray[indexPath.row].values.first
        cell.layer.cornerRadius = 5
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedIndex == indexPath.row {
            if self.isCollapce == false {
                self.isCollapce = true
            } else {
                self.isCollapce = false
            }
        } else {
            self.isCollapce = true
        }
        self.selectedIndex = indexPath.row
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: UITableViewDelegate

extension FAQViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 10
        let maskLayer = CALayer()
        
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell") as! FAQTableViewCell 

        if selectedIndex == indexPath.row && isCollapce == true {
            
            return cell.cellView.frame.height
            
        } else {
            
            return cell.cellView.frame.height - 35

        }
    }

    

    
}
