//
//  TodayMemoCell.swift
//  DayPlanner
//
//  Created by 석기권 on 7/3/24.
//

import UIKit

class TodayMemoCell: UITableViewCell {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var title: UILabel!
    
    static let reuseIdentifier = "todayMemoCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
