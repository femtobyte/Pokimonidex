//
//  Pokemon.swift
//  Pokemonidex
//
//  Created by C Sinclair on 1/19/16.
//  Copyright © 2016 femtobyte. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    //  never use an ! when declaring a var unless you absolutely know there will be a variable in there
    //  since we are guaranteeing there will be a value in these var, and the api may or may not provide a value, we
    //  will create computed properties for them
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    private var _moveList = [0]     // This array holds a list of moveID's specific to the pokemon being looked at.
    private var _moveName: String!  // to hold the move name that will be passed in from PokemonVC so I can look up certain move for learntype
    private var _learnType: String!
    
    var learnType: String {
        return _learnType
    }
    
    var moveName: String {
        return _moveName
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
   
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
  
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
  
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var moveList: [Int] {
        return _moveList
    }
  
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func setMoveName(moveName: String){
       self._moveName = moveName
    }
    
    func downloadLearnType(completed: DownloadComplete){
        let pokemonUrl =  _pokemonUrl
        let url = NSURL(string:  pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON {response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let moves = dict["moves"] as? [Dictionary<String, AnyObject>] {
                    let moveKey = moves.filter({$0["name"]?.capitalizedString == self._moveName.capitalizedString})
                    if let learnType = moveKey[0]["learn_type"] {
                        self._learnType = learnType as! String
                    }
                }
            }
            completed()
        }
    }

    func downloadPokemonDetails(completed: DownloadComplete) {
        // have to turn url's into NSURL's'
        let url = NSURL(string: _pokemonUrl)!
        // this request has a closure on it - after the download is done, run the block of code in the braces ({response in  ..code.. }
        Alamofire.request(.GET, url).responseJSON {response in
            let result = response.result
            // convert JSON into dictionary
            if let dict = result.value as? Dictionary<String, AnyObject> {
                // following is parsing the JSON dictionary, grabbing the data we want
                // need to grab it just as it's written in the JSON file, and it has to be the same type - which is sometimes hard to tel
                // so print results to test.
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                // in the Pokemon API, the types is an array.
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    // grabs the name property out of the first slot of types dictionary array
                    if let name = types[0]["name"]{
                        self._type = name.capitalizedString
                    }
                    
                //  if there are any more types, this will add them to the string along with a forward slash.  Some pokemon have no 
                //  type, sometimes they have 1, sometimes 2, don't think they have more than 2 ever.
                    if types.count > 1 {
                        for var x = 1; x < types.count; x++ {
                            if let name = types [x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    } else {
                        self._type = ""
                    }
                    print(self._type)
                }
                
                if let moves = dict["moves"] as? [Dictionary<String, AnyObject>] where moves.count > 0 {
                    if let uris = moves[0]["resource_uri"]{
                        do{
                            for move in moves {
                                if let id = move["resource_uri"] as? String{
                                    let newStr = id.stringByReplacingOccurrencesOfString("/api/v1/move/", withString: "")
                                    let numStr = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                    // following 2 lines are how I read you convert a string to int in swift 2.0.  
                                    // You use NSNumberFormatter to convert it to a NSNumber, then get it's integerValue
                                    if let num = NSNumberFormatter().numberFromString(numStr){
                                        var pokeMoveId = num.integerValue
                                        self._moveList.append(pokeMoveId)
                                        
                                    }
                                }
                            }
                        } catch {
                            print("caught: \(error)")
                        }
                        // wasn't sure how to initialize without putting a value in, seemed to stay nil.  There are no moves with id of 0, so removing this from array
                        if self._moveList[0] == 0 {
                            self._moveList.removeFirst()
                        }
                    }
                }
                
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let evolution = evolutions[0]["to"] as? String {
                        // this api has some mega pokemon that this app will not be supporting so ruling them out
                        if evolution.rangeOfString("mega") == nil {
                            // getting uri so we can extract the pokemon id from it
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                // strips off extra text from string so just number is there
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvolutionID = num
                                self._nextEvolutionTxt = evolution
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                } else {
                                    self._nextEvolutionLvl = ""
                                }
                            }
                        }
                    }
                }
                
                if let descArray = dict["descriptions"] as? [Dictionary<String, String>] where descArray.count > 0  {
                    if let url = descArray[0]["resource_uri"]{
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let descResult = response.result
                            if let descDict = descResult.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                }
                            }
                            completed() // calling completed after second download from descriptions is done
                        }
                    }
                } else {
                    self._description = ""
                    completed()
                }
                
            }
        }
    }
}