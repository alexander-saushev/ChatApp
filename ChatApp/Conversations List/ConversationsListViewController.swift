//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    var channels: [Channel] = []
    
    private let cellId = String(describing: ConversationsListCell.self)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var addChannelBarButtonItem: UIBarButtonItem!
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        let themeStoryboard: UIStoryboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
        let resultViewController = themeStoryboard.instantiateViewController(withIdentifier: "ThemesViewController") as? ThemesViewController
        guard let destinationController = resultViewController else { return }
        
        destinationController.setTheme = { [weak self] theme in
            Theme.current = theme
            self?.configureTheme(theme)
        }
        
        self.navigationController?.pushViewController(destinationController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTheme(Theme.current)
        
        profileView.layer.cornerRadius = profileView.bounds.width / 2
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ConversationsListCell", bundle: nil), forCellReuseIdentifier: "ConversationsListCell")
        
        let openProfileGesture = UITapGestureRecognizer(target: self, action: #selector(openProfile))
        profileView?.addGestureRecognizer(openProfileGesture)
        
        loadChannels()
    }
    
    private func loadChannels() {
        FirebaseManager.shared.getChannels { (result) in
            switch result {
            case .success(let channels):
                self.channels = channels.sorted {
                    $0.lastActivity ?? Date() > $1.lastActivity ?? Date()
                }
                self.tableView.reloadData()
            case .failure: break
            }
        }
    }
    
    @objc
    private func openProfile() {
        let profileStoryboard = UIStoryboard(name: "ProfileViewController", bundle: nil)
        let profileVC = profileStoryboard.instantiateViewController(withIdentifier: "ProfileViewController")
        self.present(profileVC, animated: true)
    }
    
    private func configureTheme(_ theme: ThemeModel) {
        UITableView.appearance().backgroundColor = theme.backgroundColor
        UITableViewCell.appearance().backgroundColor = theme.backgroundColor
        
        tableView?.reloadData()
        
        self.navigationController?.navigationBar.barStyle = theme.navigationBarStyle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.textColor]
        self.view.backgroundColor = theme.backgroundColor
    }
    
    @IBAction func addChannelButtonAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "New channel", message: nil, preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Create", style: .default) {_ in
            let text = alertController.textFields?.first?.text
            guard let channelName = text else { return }
            FirebaseManager.shared.addNewChannel(name: channelName)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter name"
        }
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ConversationsListCell else {
            return UITableViewCell()
        }
        let channel = channels[indexPath.row]
        cell.configure(with: channel)
        return cell
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        guard let conversationViewController = UIStoryboard(name: "ConversationViewController", bundle: nil)
                .instantiateViewController(withIdentifier: "ConversationViewController") as? ConversationViewController else {
            return
        }
        
        let chanel = channels[indexPath.row]
        conversationViewController.title = chanel.name
        conversationViewController.channel = chanel
        navigationController?.pushViewController(conversationViewController, animated: true)
        
    }
}

//extension ConversationsListViewController: ThemesPickerDelegate{
//    func setTheme(_ theme: ThemeModel) {
//        Theme.current = theme
//        configureTheme(theme)
//    }
//}
