//
//  MoveCell.swift
//  Pokemonidex
//
//  Created by C Sinclair on 1/31/16.
//  Copyright © 2016 femtobyte. All rights reserved.
//

import UIKit

class MoveCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    var moves : Moves!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(moves: Moves){
        self.moves = moves
        label.text = self.moves.name.capitalizedString
    }
}
