//
//  TripCustomTableViewCell.swift
//  FinalExam_TusharSharma_8869110
//
//  Created by Tushar Sharma on 2024-08-17.
//
//custom table view cell.
import UIKit

class TripCustomTableViewCell: UITableViewCell {

    // IB outlets.
    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var tripSource: UILabel!
    @IBOutlet weak var tripDestination: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
