//
//  ViewController.swift
//  Pokemonidex
//
//  Created by C Sinclair on 1/19/16.
//  Copyright © 2016 femtobyte. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collection: UICollectionView!
    
    var musicPlayer: AVAudioPlayer!
    @IBOutlet weak var soundBtn: UIButton!
    
    var pokemonArray = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        do{
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon (name: name, pokedexId: pokeId )
                pokemonArray.append(poke)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokieCell", forIndexPath: indexPath) as? PokieCell {
            let pokemon = pokemonArray[indexPath.row]
            cell.configureCell(pokemon)
            return cell
        } else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 718
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    @IBAction func MusicButtonPressed(sender: UIButton!) {
        
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
            // how to swap out icon?
         //   sender.setImage(MuteIcon.png, forState: false)
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        //    sender.setImage(SoundIcon.png, forState: true)
        }
    }
}

