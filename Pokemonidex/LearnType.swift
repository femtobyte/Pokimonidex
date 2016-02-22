//
//  LearnType.swift
//  Pokemonidex
//
//  Created by C Sinclair on 2/18/16.
//  Copyright © 2016 femtobyte. All rights reserved.
//

//
//  created this in effort to get the download function working properly. Once I got it working well, I plugged the download function back into the pokemon class, 
//  to see if it would work fine there, and it does.  Am leaving both options in the code, so I can look back at it for learning purposes
//

import Foundation
import Alamofire

class LearnType {

    private var _learnType: String!
    private var _moveName: String!      // holds the move name that will be passed in from PokemonVC so I can look up certain move for learntype
    private var _pokedexId: Int!        // holds the pokemon id so I can look up the list of moves for that pokemon


    
    var learnType: String {
        return _learnType
    }
    
    var moveName: String {
        return _moveName
    }
    
    
    func setMoveName(moveName: String){
        self._moveName = moveName
    }
    
    func setPokemonId(pokeId: Int){
        self._pokedexId = pokeId
    }
    
    func downloadLearnType(completed: DownloadComplete){
        let pokemonUrl =  "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
        let url = NSURL(string:  pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON {response in
            let result = response.result
           // dict = pokemon
            if let dict = result.value as? Dictionary<String, AnyObject> {
                //moves = arrays of dicts, each element has 3 String, AnyObjects: the learn_type, the resource_uri, the name
                if let moves = dict["moves"] as? [Dictionary<String, AnyObject>] {
                    // moveKey = filtered array that holds just the data pertaining to move corresponding to moveName
                    let moveKey = moves.filter({$0["name"]?.capitalizedString == self._moveName.capitalizedString})
                    // learnType = the learn_type of the move found in moveKey
                    if let learnType = moveKey[0]["learn_type"] {
                        self._learnType = learnType as! String
                    }
                }
            }
            completed()
        }
    }
}