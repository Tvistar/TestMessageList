//
//  ListView.swift
//  TestMessageList
//
//  Created by Igor Andryushenko on 27.01.2024.
//

import UIKit

class CustomListView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var longPressGesture: UILongPressGestureRecognizer!
    
    weak var viewController: UIViewController?
    
    var items: [Message] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTableView()
        configureRefreshControl()
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "ListItemCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ListItemCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as? ListItemCell else { return UITableViewCell() }
        let item = items[indexPath.row]
        cell.label.text = item.text // Текст сообщения
        cell.dateLabel.text = timestampToString(timestamp: item.timestamp) // Дата и время
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected item: \(items[indexPath.row])")
    }
    
    func configureRefreshControl () {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                                #selector(handleRefreshControl),
                                            for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        DispatchQueue.main.async {
            _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
                self.loadItems()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    func loadItems() {
        let messages = [
            Message(id: 10001, text: "text1", timestamp: 1706364230),
            Message(id: 10003, text: "text2", timestamp: 1706364231),
            Message(id: 10002, text: "text3", timestamp: 1706364232)]
        
        let setOfIDsInItems = Set(items.map { $0.id })
        
        var newMessages: [Message] = []
        for message in messages {
            if !setOfIDsInItems.contains(message.id) {
                newMessages.append(message)
            }
        }
        items.append(contentsOf: newMessages)
        items.sort { $0.timestamp < $1.timestamp }
        tableView.reloadData()
    }
    
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let textToShare = items[indexPath.row].text
                
                if let viewController = viewController {
                    let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                    
                    viewController.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = items[indexPath.row]
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
                self.shareText(item.text)
            }
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                self.deleteItem(at: indexPath)
            }
            
            return UIMenu(title: "Action", children: [shareAction, deleteAction])
        }
        
        return configuration
    }
    
    func shareText(_ text: String) {
        if let viewController = viewController {
            let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            
            viewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func timestampToString(timestamp: Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy : HH.mm"
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        return dateFormatter.string(from: date)
    }
    
    
    func scrollToBottom() {
        let rowCount = tableView.numberOfRows(inSection: 0)
        if rowCount > 0 {
            let indexPath = IndexPath(row: rowCount - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
