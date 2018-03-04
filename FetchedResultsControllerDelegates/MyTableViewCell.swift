//
//  MyTableViewCell.swift
//  FetchedResultsControllerDelegates
//
//  Created by Mazharul Huq on 3/2/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet var stateImage: UIImageView!
    
    
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
