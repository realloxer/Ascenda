//
//  ContactTableViewCell.swift
//  Ascenda
//
//  Created by LocNguyen on 10/02/2022.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    func display(_ contact: Contact, searchText: String?) {
        let attributedString = NSMutableAttributedString(string: contact.name)
        if searchText != nil {
            let range = (contact.name as NSString).range(of: searchText!)
            attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize + 1), range: range)
        }
        nameLabel.attributedText = attributedString
    }

}
