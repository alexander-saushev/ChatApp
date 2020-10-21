//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    lazy var channelsService = ChannelsService()
    
    var channels: [Channel] = []
    
    private let cellId = String(describing: ConversationsListCell.self)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var addChannelBarButtonItem: UIBarButtonItem!
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        let themeStoryboard: UIStoryboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
        let resultViewController = themeStoryboard.instantiateViewController(withIdentifier: "ThemesViewController") as? ThemesViewController
        guard let destinationController = resultViewController else { return }
        
        // destinationController.delegate = self
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
        channelsService.subscribeOnChannels { [weak self] (result) in
            switch result {
            case .success(let channels):
                DispatchQueue.main.async {
                    self?.channels = channels
                    // По-хорошему можно обновлять с анимацией добавления, перемещения канала
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Не удалось загрузить каналы: \(error)")
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
        
        let alert = UIAlertController(title: "Создать новый канад", message: "Введите название", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter channel name here..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak self] _ in
            if let name = alert.textFields?.first?.text,
               !name.isEmpty {
                self?.channelsService.createChannel(name: name) { (result) in
                    if case Result.failure(_) = result {
                        //self?.showErrorAlert(message: "Error during create new channel, try later.")
                    }
                }
            } else {
                //self?.showErrorAlert(message: "Channel name can't be empty.")
            }
        }))
        present(alert, animated: true)
        
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
