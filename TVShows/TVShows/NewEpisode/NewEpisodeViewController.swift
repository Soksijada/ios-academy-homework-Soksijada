//
//  NewEpisodeViewController.swift
//  TVShows
//
//  Created by Krešimir Baković on 24/07/2019.
//  Copyright © 2019 Krešimir Baković. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class NewEpisodeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    var token: String?
    var showID: String = "No ID"
    private var mediaId: String = "No media ID"
    private var pickerImage: UIImage?
    private var picker = UIImagePickerController()
    
    // MARK: - Outlets

    @IBOutlet private weak var image: UIImageView!
    @IBOutlet private weak var uploadPhotoButton: UIButton!
    @IBOutlet private weak var episodeTitleTextField: UITextField!
    @IBOutlet private weak var seasonNumberTextField: UITextField!
    @IBOutlet private weak var episodeNumberTextField: UITextField!
    @IBOutlet private weak var episodeDescriptionTextField: UITextField!
    
    // MARK: - Actions
    
    @IBAction private func addPhoto() {
        present(picker,animated: true)
    }
    
    @IBAction private func cancleAddingShow() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func addShow() {
        guard pickerImage != nil else {
            self.missingInputAlert()
            return
        }
        uploadImageOnAPI(token: token ?? "No token")
    }
    
    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        configurePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private functions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func missingInputAlert() {
        let alert = UIAlertController(title: "Some fields are empty", message: "Please fill all the fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func episodeAddingAlert() {
        let alert = UIAlertController(title: "Episode could not be added", message: "Error occurred", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func configurePicker() {
        picker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             image.image = pickedImage
            pickerImage = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Making new episode + Automatic JSON parsing

private extension NewEpisodeViewController {
    
    func makeNewEpisode(showId: String, mediaId: String, title: String, description: String, episodeNumber: String, season: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "showId": showId,
            "mediaId": mediaId,
            "title": title,
            "description": description,
            "episodeNumber": episodeNumber,
            "season": season
        ]
        let headers = ["Authorization": token]
        
        Alamofire.request("https://api.infinum.academy/api/episodes", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers as? HTTPHeaders)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) {
                [weak self]
            (response: DataResponse<NewEpisode>) in
            SVProgressHUD.dismiss()
            switch response.result {
            case .success(let newepisode):
                print("New episode: \(newepisode)")
                self?.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print("API failure: \(error)")
                self?.episodeAddingAlert()
            }
        }
    }
}

private extension NewEpisodeViewController {
    
    func uploadImageOnAPI(token: String) {
        let headers = ["Authorization": token]
        let someUIImage = pickerImage!
        let imageByteData = someUIImage.pngData()!
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
               method: .post,
               headers: headers)
            { [weak self] result in
                switch result {
                case .success(let uploadRequest, _, _):
                    self?.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print(encodingError)
            }
        }
    }
                
    func processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { (response:
                DataResponse<Media>) in
                switch response.result {
                case .success(let media):
                    self.mediaId = media.id
                    print("DECODED: \(media)")
                    print("Proceed to add episode call...")
                    guard let episodeTitle = self.episodeTitleTextField.text, let seasonNumber = self.seasonNumberTextField.text, let episodeNumber = self.episodeNumberTextField.text, let episodeDescription = self.episodeDescriptionTextField.text, !episodeTitle.isEmpty, !seasonNumber.isEmpty, !episodeNumber.isEmpty, !episodeDescription.isEmpty else {
                        self.missingInputAlert()
                        return
                    }
                    self.makeNewEpisode(showId: self.showID, mediaId: self.mediaId, title: episodeTitle, description: episodeDescription, episodeNumber: episodeNumber, season: seasonNumber)
                case .failure(let error):
                    print("FAILURE: \(error)")
                    self.episodeAddingAlert()
            }
        }
    }
}
