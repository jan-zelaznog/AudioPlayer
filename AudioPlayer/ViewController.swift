//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Ángel González on 29/11/24.
//

import UIKit
import AVKit
import AVFoundation
import YouTubeiOSPlayerHelper

class ViewController: UIViewController, AVAudioPlayerDelegate {

    let btnPlay = UIButton(type: .system)
    let btnStop = UIButton(type: .system)
    let sliderDuration = UISlider()
    let sliderVolume = UISlider()
    var imgContainer : UIImageView!
    var audioPlayer : AVAudioPlayer!
    var timer: Timer!
    // para cargar videos desde YouTube
    var youtubeView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let l1=UILabel()
        l1.text="AudioPlayer"
        l1.font=UIFont.systemFont(ofSize: 24)
        l1.autoresizingMask = .flexibleWidth
        l1.translatesAutoresizingMaskIntoConstraints=true
        l1.frame=CGRect(x: 0, y: 50, width: self.view.frame.width, height: 50)
        l1.textAlignment = .center
        self.view.addSubview(l1)
        
        btnPlay.setTitle("Play", for: .normal)
        btnPlay.autoresizingMask = .flexibleWidth
        btnPlay.translatesAutoresizingMaskIntoConstraints=true
        btnPlay.frame=CGRect(x: 20, y: 100, width: 100, height: 40)
        self.view.addSubview(btnPlay)
        btnPlay.addTarget(self, action:#selector(btnPlayTouch), for: .touchUpInside)
        
        sliderDuration.autoresizingMask = .flexibleWidth
        sliderDuration.translatesAutoresizingMaskIntoConstraints=true
        sliderDuration.frame=CGRect(x: 20, y:150, width: self.view.frame.width-40, height: 50)
        self.view.addSubview(sliderDuration)
        sliderDuration.addTarget(self, action:#selector(sliderDurationChange), for:.valueChanged)
        
        btnStop.setTitle("Stop", for: .normal)
        btnStop.autoresizingMask = .flexibleWidth
        btnStop.translatesAutoresizingMaskIntoConstraints=true
        btnStop.frame=CGRect(x:self.view.frame.width-100, y: 100, width: 100, height: 40)
        self.view.addSubview(btnStop)
        btnStop.addTarget(self, action:#selector(btnStopTouch), for:.touchUpInside)
        
        let l2=UILabel()
        l2.text="Volumen"
        l2.autoresizingMask = .flexibleWidth
        l2.translatesAutoresizingMaskIntoConstraints=true
        l2.frame=CGRect(x: 20, y: 200, width: 100, height: 40)
        self.view.addSubview(l2)

        sliderVolume.autoresizingMask = .flexibleWidth
        sliderVolume.translatesAutoresizingMaskIntoConstraints=true
        sliderVolume.frame=CGRect(x: 20, y: 250, width: self.view.frame.width/2, height: 50)
        self.view.addSubview(sliderVolume)
        sliderVolume.addTarget(self, action:#selector(sliderVolumeChange), for:.valueChanged)
        
        imgContainer = UIImageView(frame: CGRect(x: 0, y: 400, width: 320, height:240))
        imgContainer.translatesAutoresizingMaskIntoConstraints=true
        imgContainer.center.x = self.view.center.x
        imgContainer.backgroundColor = .gray
        self.view.addSubview(imgContainer)
        cargarAudio()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cargarVideo()
    }
    
    func cargarVideo() {
        // Reproducción de videos desde YT
        youtubeView = YTPlayerView(frame: self.imgContainer.frame)
        youtubeView.load(withVideoId:"DoyA619L9MQ")
        self.view.addSubview(youtubeView)
        /*
         // Reproducción de recursos de video
        let videoController = Reproductor()
        // esto es fullscreen
        //self.present(videoController, animated: true)
        // video incrustado:
        videoController.view.frame = self.imgContainer.frame
        // cuando agregamos la vista de un viewController como subview en otro
        // viewController, no se agrega la lógica de ejecución
        self.view.addSubview(videoController.view)
        // para agregar la lógica de programación:
        self.addChild(videoController)
        */
    }
    
    func cargarAudio() {
        guard let laURL = Bundle.main.url(forResource:"MUSIC3", withExtension:"mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: laURL)
            audioPlayer.delegate = self
            inicializarInterfaz()
        }
        catch {
            print ("no se pudo cargar el audio \(error.localizedDescription)")
        }
    }
    
    func inicializarInterfaz() {
        // sincronizamos el volumen inicial del audio con la posicion inicial del slider
        audioPlayer.volume = 0.5
        sliderVolume.value = 0.5
        // el slider duración debe incializarse con el valor de la duración en segundos
        sliderDuration.maximumValue = Float(audioPlayer.duration)
        timer = Timer.scheduledTimer(withTimeInterval:1.0, repeats:true, block: { timer in
            self.sliderDuration.value = Float(self.audioPlayer.currentTime)
        })
        audioPlayer.numberOfLoops = -1  // se reproduce indefinidamente
        audioPlayer.play()
    }
    
    @objc func btnPlayTouch(){
        //audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    @objc func sliderDurationChange(){
        audioPlayer.currentTime = Double(sliderDuration.value)
    }
    
    @objc func btnStopTouch(){
        audioPlayer.stop()
    }
    
    @objc func sliderVolumeChange(){
        audioPlayer.volume = sliderVolume.value
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer.invalidate()
    }
}

