//
//  MainViewCellTableViewCell.swift
//  Stique
//
//  Created by Nima Sepehr on 11/28/16.
//  Copyright © 2016 StiqueApp. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var vocabularyLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        //playImageView.image = UIImage(named: "cell_play")
        //optionsButton.setImage(UIImage(named: "cell_options_oval"), forState: .Normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
