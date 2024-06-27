//
//  MemoTableViewCell.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import UIKit
import RxSwift

class MemoTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MemoCell"
    @IBOutlet weak var titleLabel: UILabel!    
    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
