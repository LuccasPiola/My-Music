//
//  ViewController.swift
//  MyMusic
//
//  Created by Luccas Piola on 10/11/20.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var table: UITableView!
    let musicPlayerService = MusicPlayerService(initialSongIndex: 0)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
}

// MARK: - Table View Data Source
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicPlayerService.playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = musicPlayerService.playlist[indexPath.row]
        
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: song.imageName)
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

// MARK: - Table View Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let position = indexPath.row
        
        
        guard let vc = storyboard?.instantiateViewController(identifier: "player", creator: {coder in
            return PlayerViewController(coder: coder, position: position, musicPlayerService: self.musicPlayerService)
        }) else {
            return
        }
        present(vc, animated: true)
    }
}

