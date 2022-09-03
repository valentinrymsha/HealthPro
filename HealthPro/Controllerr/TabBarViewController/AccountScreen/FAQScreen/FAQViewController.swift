//
//  FAQViewController.swift
//  HealthPro
//
//  Created by User on 9/1/22.
//

import UIKit

class FAQViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var faqTableView: UITableView!
    
    // MARK: Properties
    
    let faqArray = [["How match api's the HealthPro uses?":"2 api's for diff goals."],
                    ["How i can logout from app?":"You can do it in the Setting's menu."],
                    ["Calculator do right?":"Yes, ofcource :)"],
                    ["Who is founder of HealthPro?":"Valentin Rymsha."],
                    ["How match account's i can to have?":"Eterniti <3"],
                    ["Whats up?":"Nice cock."],
                    ["Where localize servers of HealthPro?":"Republic of Belarus."],
                    ["How many users HealthPro have?":"Near 2m+ users."]]
    
    let faqStoryboard: UIStoryboard = UIStoryboard(name: "FAQ", bundle: nil)
    private var selectedIndex = Int()
    private var isCollapce = Bool()
    
    
    
    // MARK: Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        faqTableView.delegate = self
        faqTableView.dataSource = self
        faqTableView.rowHeight = UITableView.automaticDimension
    }

    
    // MARK: Actions
    
    
}

extension FAQViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        faqArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell") as? FAQTableViewCell else { fatalError() }
        
        let qa = faqArray[indexPath.row]
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "faqCell") as? FAQTableViewCell else { fatalError() }

        if selectedIndex == indexPath.row && isCollapce == true {
            
            return cell.cellView.frame.height
            
        } else {
            
            return cell.cellView.frame.height - 35

        }
    }

    

    
}
