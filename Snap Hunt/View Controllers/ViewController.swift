//
//  ViewController.swift
//  Snap Hunt
//
//  Created by Surjit Chowdhary on 18/01/20.
//  Copyright © 2020 Surjit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var productTableView: UITableView!

    //search bar
    lazy var searchBar:UISearchBar = UISearchBar(frame: .zero)

    //create date button
    let dateButton = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 20))

    //current date
    var currentDate = Date()

    //product view model
    let productViewModel = ProductViewModel()

    // view life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // configure UI
        self.confireUI()

        // get Data offline if any
        self.getDataOffline()

        // call today post
        self.getTodayPosts()

        //hide keyboard
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)


    }

    // configure UI
    func confireUI() {
        //initialize date button in navigation bar
        dateButton.backgroundColor = .white
        dateButton.layer.cornerRadius = 5
        dateButton.setTitleColor(ColorContant.themeColor, for: .normal)
        dateButton.setTitle(self.currentDate.toStringForDisplay(), for: .normal)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        self.navigationItem.titleView = dateButton
    }

    // Function called on date button tapped
    @objc
    func dateButtonTapped() {
        self.showDatePickerPopUp(date: self.currentDate) { [weak self] (date) in
            debugPrint(date)
            self?.currentDate = date
            self?.dateButton.setTitle(date.toStringForDisplay(), for: .normal)
            self?.navigationController?.popViewController(animated: true)
            self?.getPosts(for: date)
        }
    }

    // get Data Offline
    func getDataOffline() {
        self.productViewModel.initialLoadPosts()
    }

    // get Today posts
    func getTodayPosts() {
        self.productViewModel.getTodayPosts { [weak self] (success) in
            if success {
                DispatchQueue.main.async {
                    self?.productTableView.reloadData()
                }

            }
        }
    }

    // get posts for specific days
    func getPosts(for date: Date) {
        self.productViewModel.getPosts(for: date.toString()) { [weak self] (succes) in
            if succes {
                DispatchQueue.main.async {
                    self?.productTableView.reloadData()
                }
            }
        }
    }

    //search via name or tagline
    func search(by value: String) {
        self.productViewModel.searchPosts(by: value) { [weak self] (success) in
            if success {
                DispatchQueue.main.async {
                    self?.productTableView.reloadData()
                }
            }
        }
    }
}

// Extention for table view
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productViewModel.getPosts().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let productCell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.cellIdentifier, for: indexPath) as? ProductTableViewCell else { return UITableViewCell() }
        let post = productViewModel.getPosts()[indexPath.row]
        productCell.configureCell(post: post)
        return productCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CommentViewController.initiateCommentVC()
        vc.productViewModel = self.productViewModel
        vc.postId = Int(productViewModel.getPosts()[indexPath.row].id)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

// Extension for search Bar
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.search(by: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.search(by: searchBar.text ?? "")
    }
}

// Hide Keyboard on touch extention
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// Date Extention
extension Date {
    func toStringForDisplay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = StringConstant.displayDateFormat
        return dateFormatter.string(from: self)
    }

    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = StringConstant.totalDateFormat
        return dateFormatter.string(from: self)
    }
}
