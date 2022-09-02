//
//  TestTableCell.swift
//  Intake6RegistrationDemo
//
//  Created by AHMED on 7/21/22.
//  Copyright © 2022 IDEAEG. All rights reserved.
//

import UIKit

class TestTableCell: UITableViewCell {

    @IBOutlet weak var moviesImageView: UIImageView!
    @IBOutlet weak var moviesNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
