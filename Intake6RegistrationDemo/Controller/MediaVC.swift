//
//  MediaVC.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 8/12/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import AVKit
import SDWebImage
import SQLite

class MediaVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var activityLabel: UIActivityIndicatorView!
    
    //MARK:- Variables
    private var mediaData: [Media] = []
    private var segmentControllerValue: String = "all"
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultsManager.shared().isLoggedIn = true
        setupUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        mediaWillDisappear()
    }
    override func viewWillAppear(_ animated: Bool) {
        mediaWillAppear ()
    }
    
    //MARK:- Segment Control Config
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        let segmentIndex = sender.selectedSegmentIndex
        segmentControllerValue = sender.titleForSegment(at: segmentIndex)?.lowercased() ?? "N/A"
        switch segmentIndex {
        case 1:
            segmentControllerValue = "tvShow"
        case 2:
            segmentControllerValue = "music"
        case 3:
            segmentControllerValue = "movie"
        default:
            segmentControllerValue = "all"
        }
        callAPI()
    }
    
    // MARK:- Profile button Config
    @objc func profileTapped() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "ProfileVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

    //MARK:- Table View Delegate
extension MediaVC: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

    //MARK:- Table View DataSource
extension MediaVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mediaData.count == 0 {
            tableView.isHidden = true
            imageView.isHidden = false
            return 0
        }
        tableView.isHidden = false
        imageView.isHidden = true
        return mediaData.count
    }
    
    //MARK:- Cell Config.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ITunesCell", for: indexPath) as! ITunesCell
        cell.setupCell(type: segmentControllerValue, mediaData: mediaData[indexPath.row])
        
        return cell
        
    }
    //MARK:- Preview presentation.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoUrl = mediaData[indexPath.row].previewUrl ?? ""
        let playerVC = AVPlayerViewController()
        var playerView = AVPlayer()
        let url: URL = URL(string: videoUrl)!
        playerView = AVPlayer(url: url as URL)
        playerVC.player = playerView
        self.present(playerVC, animated: true)
        playerVC.player?.play()
    }
}

    // MARK:- Setup UI.
extension MediaVC {
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        self.navigationItem.title = "Media List"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(profileTapped))
        let nib = (UINib(nibName: "ITunesCell", bundle: nil))
        tableView.register(nib, forCellReuseIdentifier: "ITunesCell")
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.hidesBackButton = true
        tableView.separatorColor = .black
    }
    
    //MARK:-  API call
    private func callAPI() {
        activityAppears()
        APIManager.loadMediaData(term: searchBar.text ?? "No data in search", media: segmentControllerValue) { error, response in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else if let data = response {
                self.mediaData = data
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK:- Activity setup.
    private func activityAppears() {
        activityLabel.isHidden = false
        activityLabel.startAnimating()
    }
    private func activityDisppears() {
        activityLabel.isHidden = true
        activityLabel.stopAnimating()
    }
}

    //MARK:- Search bar Config.
extension MediaVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.count ?? 0) >= 3 {
            callAPI()
            
        } else {
            tableView.isHidden = true
            imageView.isHidden = false
            imageView.image = UIImage(named: "Image Not found")
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        mediaData.removeAll()
        tableView.reloadData()
        activityDisppears()
        tableView.isHidden = false
        imageView.isHidden = true
        continueSearching(message: "what are you waiting for! \n start searching now. 🤘🏻")
        
    }
}

extension MediaVC {
    
    //MARK:- encode Media.
    private func encodeMediaToData(media: MediaData) -> Data? {
        do {
            let encoder = JSONEncoder()
            let mediaData = try encoder.encode(media)
            return mediaData
        } catch {
            print("Unable to Encode mediaData (\(error))")
        }
        return nil
    }
    
    //MARK:- segment controller Func.
    private func setupSegment(mediaType: String){
        switch mediaType {
        case "tvShow":
            segmentController.selectedSegmentIndex = 1
        case "music":
            segmentController.selectedSegmentIndex = 2
        case "movie":
            segmentController.selectedSegmentIndex = 3
        default:
            segmentController.selectedSegmentIndex = 0
        }
    }
    
    //MARK:- View Will Appear Func.
    private func mediaWillAppear() {
        if let data = SQlManager.sharedObject().getMediaData(email: UserDefaultsManager.shared().email) {
            self.mediaData = data.mediaData
            setupSegment(mediaType: data.mediaType ?? "all")
            self.tableView.reloadData()
        } else {
            startSearching(message: "Start searching.😎 ")
        }
    }
    
    //MARK:- View Will Disappear Func.
    private func mediaWillDisappear() {
        let media = MediaData(mediaType: segmentControllerValue, mediaData: mediaData)
        guard let data = encodeMediaToData(media: media) else {
            print("no data entered.")
            return
        }
        SQlManager.sharedObject().updateMedia(email: UserDefaultsManager.shared().email, userMedia: data)
    }
}
