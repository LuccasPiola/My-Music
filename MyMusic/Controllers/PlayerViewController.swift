//
//  PlayerViewController.swift
//  MyMusic
//
//  Created by Luccas Piola on 10/11/20.
//
import AVFoundation
import UIKit

class PlayerViewController: UIViewController {
    // MARK: - Attributes
    var songIndex: Int
    var musicPlayerService: MusicPlayerService
    
    // MARK: - Life Cycle
    init?(coder: NSCoder, position: Int, musicPlayerService: MusicPlayerService) {
        self.songIndex = position
        self.musicPlayerService = musicPlayerService
        self.musicPlayerService.playingSongIndex = position
        self.musicPlayerService.buildPlayerWithSong(at: position)
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = musicPlayerService.player {
            player.stop()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var holder: UIView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!

    // MARK: - Methods
    func configure() {
        musicPlayerService.perform(action: .playOrPause)
        changeImageAndLabels(song: musicPlayerService.actualSong)
    }
    
    func changeImageAndLabels(song: Song) {
        guard let player = musicPlayerService.player else {
            return
        }
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        songImage.image = UIImage(named: song.imageName)
        
        let iconName = player.isPlaying ? "pause" : "play"
        playButton.setBackgroundImage(UIImage(systemName: "\(iconName).fill"), for: .normal)
    }
    
    // MARK: - IBActions
    @IBAction func valueFromSliderChanged() {
        musicPlayerService.player?.setVolume(volumeSlider.value, fadeDuration: TimeInterval())
    }
    
    @IBAction func didTapPlay(_ sender: Any) {
        guard let player = musicPlayerService.player else {
            return
        }
        musicPlayerService.perform(action: .playOrPause)
        let iconName = player.isPlaying ? "pause" : "play"
        playButton.setBackgroundImage(UIImage(systemName: "\(iconName).fill"), for: .normal)
    }
    
    @IBAction func didTapForward(_ sender: Any) {
        musicPlayerService.perform(action: .nextMusic)
        changeImageAndLabels(song: musicPlayerService.actualSong)
    }
    
    @IBAction func didTapBackward(_ sender: Any) {
        musicPlayerService.perform(action: .previousMusic)
        changeImageAndLabels(song: musicPlayerService.actualSong)
    }
}
