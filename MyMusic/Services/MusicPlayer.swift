//
//  MusicPlayer.swift
//  MyMusic
//
//  Created by Luccas Piola on 11/11/20.
//

import AVFoundation
import UIKit

public enum Actions {
    case playOrPause
    case nextMusic
    case previousMusic
}

public class MusicPlayerService {
    // MARK: - Attributes
    var playlist: [Song] = [
        Song(
            name: "Havana",
            albumName: "Havana Album",
            artistName: "Camila Cabello",
            imageName: "cover1",
            trackName: "havana"),
        Song(
            name: "Shape Of You",
            albumName: "Divide",
            artistName: "Ed Sheeran",
            imageName: "cover3",
            trackName: "shapeofyou"),
        Song(
            name: "Up & Up",
            albumName: "Head Full of Dreams",
            artistName: "Coldplay",
            imageName: "cover2",
            trackName: "upandup")
    ]
    var playingSongIndex: Int
    var player: AVAudioPlayer?
    var actualSong: Song {
        get {
            return playlist[playingSongIndex]
        }
    }
    
    // MARK: - Life Cycle
    init(initialSongIndex: Int) {
        self.playingSongIndex = initialSongIndex
        initialConfiguration()
        buildPlayerWithSong(at: initialSongIndex)
    }
    
    // MARK: - Methods
    private func initialConfiguration() {
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Error initializing the player")
        }
    }
    
    func buildPlayerWithSong(at index: Int) {
        self.playingSongIndex = index
        let song = actualSong
        guard let songUrl: String = Bundle.main.path(forResource: song.trackName, ofType: "mp3") else {
            print("Cannot find the file in specified path")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: URL(string: songUrl)!)
            self.player = player
        } catch {
            print("Could not instantiate player by the given mp3 url")
        }
    }
    
    func perform(action: Actions) {
        switch action {
        case .playOrPause:
            playPause()
        case .nextMusic:
            nextMusic()
        case .previousMusic:
            previousMusic()
        }
    }
    
    func playPause() {
        guard let player = player else {
            return
        }
        
        if(player.isPlaying) {
            player.pause()
            return
        }
        player.play()
    }
    
    func nextMusic() {
        let finalIndex = playlist.count - 1
        let position = playingSongIndex == finalIndex ? 0 : playingSongIndex + 1
        buildPlayerWithSong(at: position)
        playPause()
    }
    
    func previousMusic() {
        let finalIndex = playlist.count - 1
        let position = playingSongIndex == 0 ? finalIndex : playingSongIndex - 1
        buildPlayerWithSong(at: position)
        playPause()
    }
}
