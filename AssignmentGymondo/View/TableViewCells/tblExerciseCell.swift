//
//  tblExerciseCell.swift
//  AssignmentGymondo
//
//  Created by Amit on 02/05/22.
//

import UIKit

class tblExerciseCell: UITableViewCell {
    //UI Objects
    @IBOutlet weak var lblExercise: UILabel!
    @IBOutlet weak var imgExercise: UIImageView!

    var exercise : ExercisesData? {
        didSet {
            lblExercise.text = exercise?.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
