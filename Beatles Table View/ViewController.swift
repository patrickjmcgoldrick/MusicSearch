//
//  ViewController.swift
//  Beatles Table View
//
//  Created by dirtbag on 11/21/19.
//  Copyright © 2019 dirtbag. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var uniqueResults : [Result]?
    
    var beatles = ["John", "Paul", "George", "Ringo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        parseJSONinBackground()
    }

    func parseJSONinBackground() {

        guard let artistJsonPath = Bundle.main.path(forResource: "beatles", ofType: "json") else { print ("failed to load file."); return }
        
        
        let url = NSURL.fileURL(withPath: artistJsonPath)// else { print ("invalid URL"); return }

        print (url)
        
        DispatchQueue.global().async {

            do {
                let data = try Data(contentsOf: url)
                let jsonDecoder = JSONDecoder()

                let albumData = try jsonDecoder.decode(AlbumData.self, from: data)
                
                self.uniqueResults = albumData.results.reduce([], {
                    $0.contains($1) ? $0 : $0 + [$1]
                })
            } catch {
                print (error.localizedDescription)
            }

            DispatchQueue.main.async {
                print(self.uniqueResults?.count)
                print(self.uniqueResults!)

            }
        }
     }

    

}

extension ViewController : UITableViewDelegate {
    
}

extension ViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return uniqueResults?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        cell.lblAlbumName.text = uniqueResults?[indexPath.row].collectionName ?? ""
        
        return cell
    }
    
    
}

