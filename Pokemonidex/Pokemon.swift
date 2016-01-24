//
//  Pokemon.swift
//  Pokemonidex
//
//  Created by C Sinclair on 1/19/16.
//  Copyright © 2016 femtobyte. All rights reserved.
//

import Foundation

class Pokemon {
    //  never use an ! when declaring a var if you absolutely know there will be a variable in there
    private var _name: String!
    private var _pokedexId: Int!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    //  with this init, you can't make a Pokemon object without filling hte above vars
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
    }
}