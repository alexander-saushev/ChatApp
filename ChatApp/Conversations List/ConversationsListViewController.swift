//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileView: UIView!
    
    var conversationsList: [[ConversationCellModel]] = []
    
    private func sortArrayByStatus(array: [ConversationCellModel]) -> [[ConversationCellModel]] {
        var sortedByStatusArray: [[ConversationCellModel]] = [[],[]]
        for (index, item) in array.enumerated(){
            if item.isOnline{
                sortedByStatusArray[0].append(array[index])
            } else {
                sortedByStatusArray[1].append(array[index])
            }
        }
        return sortedByStatusArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        conversationsList = sortArrayByStatus(array: conversationsListExample)
        
        profileView.layer.cornerRadius = profileView.bounds.width / 2
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ConversationsListCell", bundle: nil), forCellReuseIdentifier: "ConversationsListCell")
        
        let openProfileGesture = UITapGestureRecognizer(target: self, action: #selector(openProfile))
        profileView?.addGestureRecognizer(openProfileGesture)
    }
    
    @objc
    private func openProfile() {
        let profileStoryboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController")
        self.present(profileVC, animated: true)
    }
}

extension ConversationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return conversationsList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        } else {
            return "History"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationsList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ConversationsListCell = tableView.dequeueReusableCell(withIdentifier: "ConversationsListCell") as? ConversationsListCell
        guard let cell = ConversationsListCell else { return UITableViewCell()}
        
        let item = conversationsList[indexPath.section][indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = conversationsList[indexPath.section][indexPath.row].name
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "ConversationViewController", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController
        guard let destinationController = resultViewController else { return }
        destinationController.name = name
        self.navigationController?.pushViewController(destinationController, animated: true)
        
    }
}
