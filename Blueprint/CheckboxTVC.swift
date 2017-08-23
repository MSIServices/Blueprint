//
//  CheckboxTVC.swift
//  Blueprint
//
//  Created by Stephen Muscarella on 8/21/17.
//  Copyright © 2017 Stephen Muscarella. All rights reserved.
//

import UIKit
import M13Checkbox

class CheckboxTVC: UITableViewCell {

    @IBOutlet weak var checkboxV: M13Checkbox!
    @IBOutlet weak var titleLbl: UILabel!
    
    var group: Group?
    var checkboxDelegate: CheckboxDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        checkboxV.markType = .checkmark
        checkboxV.boxType = .square
        checkboxV.checkState = .checked
        checkboxV.checkmarkLineWidth = 2.0
        checkboxV.stateChangeAnimation = .fill
        checkboxV.cornerRadius = 3
        checkboxV.tintColor = CHAIN_CREAM
    }
    
    class func nib() -> UINib {
        return UINib(nibName: "CheckboxTVC", bundle: nil)
    }
    
    func configureCell(title: String) {
        titleLbl.text = title
        
        if title != "Connections" {
            checkboxV.checkState = .unchecked
        }
    }
    
    func configureGroup(group: Group) {
        self.group = group
        titleLbl.text = group.name
    }
    
    @IBAction func checkboxPressed(_ sender: Any) {
        checkboxDelegate.update(name: titleLbl.text!)
    }
}
