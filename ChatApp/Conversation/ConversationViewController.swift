//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTheme()
        
        self.title = name
        
        chatTableView?.delegate = self
        chatTableView?.dataSource = self
        chatTableView?.register(UINib(nibName: String(describing: ConversationCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ConversationCell.self))
    }
    
    private func setTheme() {
        self.view.backgroundColor = Theme.current.backgroundColor
    }
    
}

extension ConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageExample.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ConversationCell.self)) as? ConversationCell else { return UITableViewCell() }
        
        let message = messageExample[indexPath.row]
        cell.configure(with: message)
        
        return cell
    }
}
