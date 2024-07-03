//
//  CalendarCell.swift
//  DayPlanner
//
//  Created by 석기권 on 6/28/24.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    static let reuseIdentifier = "calCell"
    @IBOutlet weak var dayOfMonth: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    
    @IBOutlet weak var innerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        innerView.layer.cornerRadius = innerView.frame.size.width / 2        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    func seletedCell() {
        innerView.backgroundColor = .darkGray
        dayOfMonth.textColor = .white
    }
    
    func resetCell() {
        innerView.backgroundColor = .systemGray6
        dayOfMonth.textColor = .darkGray
    }
}
