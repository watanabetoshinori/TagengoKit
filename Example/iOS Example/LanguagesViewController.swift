//
//  LanguagesViewController.swift
//  iOS Example
//
//  Created by Watanabe Toshinori on 12/28/18.
//  Copyright © 2018 Watanabe Toshinori. All rights reserved.
//

import UIKit
import TagengoKit

protocol LanguagesViewControllerDelegate: class {
    func languagesViewController(_ viewController: LanguagesViewController, didSelectLanguage: Language)
}

class LanguagesViewController: UITableViewController {
    
    weak var delegate: LanguagesViewControllerDelegate?
    
    var selectedLanguage: Language!
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let language = Language.allCases[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = language.displayValue
        cell.accessoryType = (selectedLanguage == language) ? .checkmark : .none
        return cell
    }

    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = Language.allCases[indexPath.row]
        
        selectedLanguage = language

        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
    }
    
    // MARK: - Actions
    
    @IBAction func doneTapped(_ sender: Any) {
        self.delegate?.languagesViewController(self, didSelectLanguage: selectedLanguage)

        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
