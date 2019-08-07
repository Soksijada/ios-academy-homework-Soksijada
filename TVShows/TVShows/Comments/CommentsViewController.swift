//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 28/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class CommentsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var noCommentLabel: UILabel!
    @IBOutlet weak var noCommentImage: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    
    var episode: Episode?
    var token: String?
    var listOfComments: [Comment] = []
    private let refresherControl = UIRefreshControl()
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchComments()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        settingRefreshController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction private func postComment() {
            SVProgressHUD.show()
            let headers = ["Authorization": token]
            let body: [String:String] = [ "text": commentTextField.text!,
                                          "episodeId": episode?.id ?? "No id" ]
            Alamofire
                .request("https://api.infinum.academy/api/comments/",
                         method: .post,
                         parameters: body,
                         encoding: JSONEncoding.default,
                         headers: headers as? HTTPHeaders
                )
                .validate()
                .responseData() { [weak self] response in
                    switch response.result {
                    case .success( _):
                        SVProgressHUD.dismiss()
                        self?.commentTextField.text = ""
                        self?.fetchComments()
                    case .failure( _):
                        SVProgressHUD.showError(withStatus: "Failure")
                }
            }
        }
    
    @IBAction private func navigateBackToEpisodeDetails() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private functions
    
    @objc private func updateTableView() {
        fetchComments()
        let delay = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
            self?.refresherControl.endRefreshing()
        }
    }
    
    @objc private func keyBoardWillShow(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        stackViewBottomConstraint.constant = (keyboardHeight - bottomPadding!)
        tableViewBottomConstraint.constant = tableViewBottomConstraint.constant + (keyboardHeight - bottomPadding!)
        print(keyboardHeight)
    }
    
    @objc private func keyBoardWillHide(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        stackViewBottomConstraint.constant -= (keyboardHeight - bottomPadding!)
        tableViewBottomConstraint.constant -= (keyboardHeight - bottomPadding!)
        print(keyboardHeight)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func settingRefreshController() {
        refresherControl.addTarget(self, action: #selector(updateTableView), for: .valueChanged)
        tableView.refreshControl = refresherControl
    }
    
    private func checkIfThereAreSomeComments() {
        if self.listOfComments.count == 0 {
            self.noCommentImage.isHidden = false
            self.noCommentLabel.isHidden = false
        } else {
            self.noCommentImage.isHidden = true
            self.noCommentLabel.isHidden = true
        }
    }
}

// MARK: - Setting up table view

private extension CommentsViewController {
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfComments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCell.self), for: indexPath) as! CommentCell
        cell.configure(with: listOfComments[indexPath.row])
        return cell
    }
}

// MARK: - Fetching comments + Automatic JSON parsing

private extension CommentsViewController {
    func fetchComments() {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes/\(episode?.id ?? "asca")/comments",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers as? HTTPHeaders
            ).validate()
            .responseDecodableObject(keyPath: "data") {
                (response: DataResponse<[Comment]>) in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let comments):
                    print("Success this is your comment list:")
                    self.listOfComments = comments.map { commentInComments in
                        var comment = Comment(text: "No text", episodeId: "No ID", userEmail: "No email", id: "No ID")
                        comment.text = commentInComments.text
                        comment.episodeId = commentInComments.episodeId
                        comment.userEmail = commentInComments.userEmail
                        comment.id = commentInComments.id
                        return comment
                    }
                    self.checkIfThereAreSomeComments()
                    print(comments)
                    self.tableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
            }
        }
    }
}
