//
//  SuggestionViewCell.swift
//  MapApp
//
//  Created by Apple on 10/06/18.
//  Copyright © 2018 Tushar. All rights reserved.
//

import UIKit

class SuggestionViewCell: UITableViewCell {

    @IBOutlet weak var PrimaryLabel: UILabel!
    @IBOutlet weak var SecondaryLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
