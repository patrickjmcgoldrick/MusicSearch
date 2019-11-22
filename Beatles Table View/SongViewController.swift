//
//  SongViewController.swift
//  Beatles Table View
//
//  Created by dirtbag on 11/22/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit
import SDWebImage

class SongViewController: UIViewController {

    @IBOutlet weak var ivAlbumCover: UIImageView!
    
    @IBOutlet weak var songTableView: UITableView!

    
    var albumTitle = String()
    var albumImage : String?
    var tracks : [Result]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = albumTitle
        if let artworkUrl = albumImage {
            ivAlbumCover.sd_setImage(with: URL(string: artworkUrl))
        }
        if let songs = tracks {
            tracks = songs.sorted{
                $0.trackNumber ?? 0 < $1.trackNumber ?? 0
            }
            
        }
    }

}

extension SongViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tracks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell
        
        cell.lblTitle.text = tracks?[indexPath.row].trackName ?? ""
        
        if let trackNumber = tracks?[indexPath.row].trackNumber {
            cell.lblTrackNumber.text = "Track: \(trackNumber)"
        }
        
        if let time = tracks?[indexPath.row].trackTimeMillis{
            cell.lblTime.text = formatTime(millis: time)
        }
        
        return cell
    }
    
    /// Format milliseconds into ##:## format
    private func formatTime(millis: Int) -> String {

        let seconds = millis / 1000
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional

        let formattedString = formatter.string(from: TimeInterval(seconds))!
        
        return formattedString
    }
    
    
}
