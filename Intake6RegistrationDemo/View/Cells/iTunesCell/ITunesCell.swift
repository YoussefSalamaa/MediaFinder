//
//  ITunesCell.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 8/18/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import UIKit

class ITunesCell: UITableViewCell {
    
    //MARK:- Outlets.
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var mediaHeaderLabel: UILabel!
    @IBOutlet weak var mediaSubTitleLabel: UILabel!
    
    //MARK:- Life Cycle.
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK:- Public Cell Config.
    func setupCell(type: String, mediaData: Media) {
        setupImageView(mediaUrl: mediaData.artworkUrl)
        setupCellData(type: type, mediaData: mediaData)
    }
    
    //MARK:- Animation Action.
    @IBAction func bounceBttnTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0, options: .autoreverse, animations: {
            self.mediaImageView.frame = CGRect(x: 8, y: 8, width: 75, height: 75)
            self.mediaImageView.center.x += 5
            
        }, completion: {
            finished in
            self.mediaImageView.frame.origin.x = 8
            
            UIView.animate(withDuration: 0.15, delay: 0, options: .autoreverse, animations: {
                self.mediaImageView.center.x -= 5
                
            }, completion: {
                finished in
                self.mediaImageView.frame.origin.x = 8
            }
            )}
        )
    }
}

//MARK:- Private Cell Config.
extension ITunesCell {
    
    private func setupImageView(mediaUrl: String) {
        mediaImageView.sd_setImage(with: URL(string: mediaUrl), placeholderImage: UIImage(named: "placeholder"))
    }
    private func setupCellData(type: String, mediaData: Media) {
        switch type  {
        case "tvShow":
            mediaHeaderLabel.text = mediaData.artistName ?? "No artist name"
            mediaSubTitleLabel.text = mediaData.longDescription ?? "No description"
        case "music":
            mediaHeaderLabel.text = mediaData.artistName ?? "No artist name"
            mediaSubTitleLabel.text = mediaData.trackName ?? "No track name"
        case "movie":
            mediaHeaderLabel.text = mediaData.trackName ?? "No track name"
            mediaSubTitleLabel.text = mediaData.longDescription ?? "No description"
        default:
            if mediaData.longDescription == nil {
                mediaHeaderLabel.text = mediaData.artistName ?? "No artist name"
                mediaSubTitleLabel.text = mediaData.trackName ?? "No track name"
            }else if mediaData.trackName == nil{
                mediaHeaderLabel.text = mediaData.artistName ?? "No artist name"
                mediaSubTitleLabel.text = mediaData.longDescription ?? "No description"
            }else{
                mediaHeaderLabel.text = mediaData.trackName ?? "No track name"
                mediaSubTitleLabel.text = mediaData.longDescription ?? "No description"
            }
        }
    }
}
