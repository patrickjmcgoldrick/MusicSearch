//
//  ViewController.swift
//  Beatles Table View
//
//  Created by dirtbag on 11/21/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var albums : [Result]?
    var allSongs : [Result]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        parseJSONinBackground()
    }

    func parseJSONinBackground() {

        // create filesystem path
        guard let artistJsonPath = Bundle.main.path(forResource: "beatles", ofType: "json") else { print ("Failed to load file."); return }
        
        
        // convert into URL
        let url = NSURL.fileURL(withPath: artistJsonPath)
        
        // background the loading / parsing elements
        DispatchQueue.global().async {

            do {
                // load json into Data object
                let data = try Data(contentsOf: url)
                
                // create decoder
                let jsonDecoder = JSONDecoder()

                // decode json into structs
                let albumData = try jsonDecoder.decode(AlbumData.self, from: data)
                
                // save track rows for detail view
                self.allSongs = albumData.results
                
                // filter for only the albums
                self.albums = albumData.results.reduce([], {
                    $0.contains($1) ? $0 : $0 + [$1]
                })
                
            } catch {
                print ("Error Parsing JSON: \(error.localizedDescription)")
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCollectionId = albums?[indexPath.row].collectionId
        
        let tracksInCollection = allSongs?.filter { $0.collectionId == selectedCollectionId }            
        print ("rows: \(tracksInCollection)")
        
    }
}

extension ViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return albums?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        cell.lblAlbumName.text = albums?[indexPath.row].collectionName ?? ""
        
        if let imageUrl = albums?[indexPath.row].artworkUrl100 {
            cell.ivAlbum.sd_setImage(with: URL(string: imageUrl))
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "SongSegue" {
            
            let destination = segue.destination as? SongViewController
            guard let albumIndex = tableView.indexPathForSelectedRow?.row else { return }
            
            let album = albums?[albumIndex]
            let selectedCollectionId = albums?[albumIndex].collectionId
             
             let tracksInCollection = allSongs?.filter { $0.collectionId == selectedCollectionId }

            destination?.albumTitle = album?.collectionName ?? ""
            destination?.albumImage = album?.artworkUrl100
            
            if let tracks = tracksInCollection {
                destination?.tracks = tracks
            }
        }
    }
}

