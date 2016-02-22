//
//  PokemonDetailVC.swift
//  Pokemonidex
//
//  Created by C Sinclair on 1/25/16.
//  Copyright © 2016 femtobyte. All rights reserved.
//
//  successfully got data download working in both pokemon.swift, and in learnType.swift.  
//  in pokemon.swift, I only have to pass in moveName, and I only need a pokemon var in the PokemonDetailVC.
//  
//  using learnType.swift, I have to pass in moveName and pokemonID, and I need a learnType var in PokemonDetailVC.

import UIKit

class PokemonDetailVC: UIViewController, MovesVCDelegate {
    var pokemon: Pokemon!
    var learntype = LearnType()

    @IBOutlet weak var segments: UISegmentedControl!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var topLeftLbl: UILabel!    //Top left // type or move
    @IBOutlet weak var topRightLbl: UILabel! //Top right // defense or move id
    @IBOutlet weak var midLeftLbl: UILabel!  //Mid left // height or learn type
    @IBOutlet weak var midRightLbl: UILabel! //mid right // pokedexid or power
    @IBOutlet weak var btmLeftLbl: UILabel!  //btm left  // weight or accuracy
    @IBOutlet weak var btmRightLbl: UILabel! //btm right // base attack or pp
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    @IBOutlet weak var topTitleLeft: UILabel!
    @IBOutlet weak var topTitleRight: UILabel!
    @IBOutlet weak var midTitleLeft: UILabel!
    @IBOutlet weak var midTitleRight: UILabel!
    @IBOutlet weak var btmTitleLeft: UILabel!
    @IBOutlet weak var btmTitleRight: UILabel!
    
    
    var chosenMoveToDisplay : Moves!
    var loaded : Bool = false
    
    // passing data from MovesVC back to PokemonDetailVC with protocol delegate pattern
    func acceptData(data: AnyObject!){
        chosenMoveToDisplay = data as! Moves
        
        pokemon.setMoveName(chosenMoveToDisplay.name)
        pokemon.downloadLearnType { () -> () in
            self.movesUI()
        }
//        // To use learnType.swift class instead of pokemon.swift to get the learnType, comment out/delete the 3 lines above,
//        // and replace with the following commented out lines:
//        learntype.setPokemonId(pokemon.pokedexId)
//        learntype.setMoveName(chosenMoveToDisplay.name) // there is an unwrapped nil here.  not sure why,
//        learntype.downloadLearnType { () -> () in
//            self.movesUI()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        segments.enabled = false
        pokemon.downloadPokemonDetails { () -> () in
            // this will be called after download is done
            // this is in a closure, so we need to identify the function as self.
            self.segments.enabled = true
            self.loaded = true
            self.bioUI()
        }
    }
    
    func bioUI(){
        nameLbl.text = "\(pokemon.name.capitalizedString)"
        topTitleLeft.text = "Type:"
        topTitleRight.text = "Defense:"
        midTitleLeft.text = "Height:"
        midTitleRight.text = "Pokedex ID:"
        btmTitleLeft.text = "Weight:"
        btmTitleRight.text = "Base Attack:"
        
        descLbl.text = pokemon.description
        topLeftLbl.text = pokemon.type
        topRightLbl.text = pokemon.defense
        midLeftLbl.text = pokemon.height
        midRightLbl.text = pokemon.weight
        btmLeftLbl.text = pokemon.attack
        btmRightLbl.text = "\(pokemon.pokedexId)"
        
        if pokemon.nextEvolutionID == "" {
            nextEvoLbl.text = "No Evolutions"
            nextEvoImg.hidden = true
        } else {
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionID)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            // if pokemon evolves at a level, include lvl on it
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
        }
    }
    
    func movesUI(){
        topTitleLeft.text = "Move:"
        topTitleRight.text = "Move ID:"
        midTitleLeft.text = "LearnType:"
        midTitleRight.text = "Power:"
        btmTitleLeft.text = "Accuracy:"
        btmTitleRight.text = "PP:"
        
        topLeftLbl.text = chosenMoveToDisplay.name.capitalizedString
        topRightLbl.text = "\(chosenMoveToDisplay.movesID)"
        descLbl.text = chosenMoveToDisplay.moveDescription
//        midLeftLbl.text = learntype.learnType     // use this line if you are using learntype.swift
        midLeftLbl.text = pokemon.learnType.capitalizedString
        midRightLbl.text = chosenMoveToDisplay.movePower
        btmLeftLbl.text = chosenMoveToDisplay.moveAccuracy
        btmRightLbl.text = chosenMoveToDisplay.movePP
    }
    
    
    @IBAction func onBackPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func segmentSelected(sender: AnyObject) {
        if(loaded){
            switch segments.selectedSegmentIndex
            {
            case 0:
                bioUI()
            case 1:
                do{
                    let mvc = storyboard?.instantiateViewControllerWithIdentifier("MovesVC") as! MovesVC
                    mvc.data = pokemon.moveList
                    mvc.delegate = self
                    self.presentViewController(mvc, animated: true, completion: nil)
                } catch let err as NSError {
                    print(err.debugDescription)
            }
            default:
                break
            }
        }
    }
}
