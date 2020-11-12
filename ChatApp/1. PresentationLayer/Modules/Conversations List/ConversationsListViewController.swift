//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Александр Саушев on 28.09.2020.
//  Copyright © 2020 Александр Саушев. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UIViewController {
    
    private let cellId = String(describing: ConversationsListCell.self)
    
    private var fetchedResultsController: NSFetchedResultsController<Channel_db>!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var addChannelBarButtonItem: UIBarButtonItem!
    
    var presentationAssembly: IPresentationAssembly?
    var model: IConversationsListModel?

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
        guard let model = self.model else { return }
        model.getChannels()
        self.fetchedResultsController = model.fetchedResultController()
        try? self.fetchedResultsController.performFetch()
        self.fetchedResultsController.delegate = self
    }
    
    @objc
    private func openProfile() {
        
        guard let presentationAssembly = self.presentationAssembly else { return }
        let profileVC = presentationAssembly.profileViewController()
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
        alertController.addTextField()
        
        let createAction = UIAlertAction(title: "Create", style: .default) {_ in
            let text = alertController.textFields?.first?.text
            
            let visibleSymbols = NSCharacterSet.whitespacesAndNewlines.inverted
            let range = text?.rangeOfCharacter(from: visibleSymbols)
            
            guard let channelName = text, let model = self.model, range != nil else {
                let errorAlert = UIAlertController(title: "Error", message: "You can't create channel without name", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                return }
            model.insertChannel(name: channelName)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
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
        guard let sections = fetchedResultsController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ConversationsListCell else {
            return UITableViewCell()
        }
        let channel = fetchedResultsController.object(at: indexPath)
        cell.configure(with: channel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
              let channel = fetchedResultsController.object(at: indexPath)
              guard let model = self.model else { return }
              model.deleteChannel(channel: channel)
        }
    }
}

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        guard let presentationAssembly = self.presentationAssembly else { return }
        let conversationViewController = presentationAssembly.conversationViewController()
        
        let channel = fetchedResultsController.object(at: indexPath)
        conversationViewController.title = channel.name
        conversationViewController.channel = channel
        navigationController?.pushViewController(conversationViewController, animated: true)
        
    }
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .automatic)
    case .move:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
    @unknown default:
      fatalError()
    }
  }
}

//extension ConversationsListViewController: ThemesPickerDelegate{
//    func setTheme(_ theme: ThemeModel) {
//        Theme.current = theme
//        configureTheme(theme)
//    }
//}
