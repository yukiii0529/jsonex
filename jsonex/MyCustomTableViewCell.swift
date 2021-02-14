//
//  MyCustomTableViewCell.swift
//  jsonex
//
//  Created by 田中勇輝 on 2020/12/11.
//  Copyright © 2020 WEB. All rights reserved.
//

import UIKit

class MyCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var MakerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
