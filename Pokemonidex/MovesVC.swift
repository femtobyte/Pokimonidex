//
//  MovesVC.swift
//  Pokemonidex
//
//  Created by C Sinclair on 1/31/16.
//  Copyright © 2016 femtobyte. All rights reserved.
//

import UIKit

//using protocol/delegate method to return info to PokemonDetailVC
protocol MovesVCDelegate {
    func acceptData(data: AnyObject!)
}

class MovesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var moves: Moves!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var movesArray = [Moves]()
    var arrayOfMoveIDs = [Int]()
    var filteredArray = [Moves]()
    var delegate : MovesVCDelegate?
    var data : AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        arrayOfMoveIDs = (data as? [Int])!
        parseMovesCSV()
    }
    
    override func viewWillAppear(animated: Bool) {
        filterMoves()
    }
 
    func filterMoves() {
        for arrayOfMoveID in arrayOfMoveIDs{
        //  var newArray = movesArray.filter{$0.movesID == arrayOfMoveIDs} //compiler didn't like this way
            let newArray = movesArray[(arrayOfMoveID - 1)] //this gave me an array of pokemonidex.moves, of the right name/number except off by one (moveId 21 instead of 20)
            filteredArray.append(newArray)
        }
    }
    
        
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfMoveIDs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let moves = filteredArray[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("MoveCell") as? MoveCell {
            cell.configureCell(moves)
            return cell
        } else {
            let cell = MoveCell()
            return cell
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        moves = self.filteredArray[indexPath.row]
        //before sending this array back, fill it up with rest of data.
        moves.downloadPokemonDetails { () -> () in
            // this will be called after download is done
            // this is in a closure, so we need to identify the function as self.
            self.delegate?.acceptData(self.moves)
            self.dismissViewControllerAnimated(true, completion: nil)
        }

    }
    
    @IBAction func onBackBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func parseMovesCSV(){
        let path = NSBundle.mainBundle().pathForResource("moves", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows{
                let moveId = Int(row["id"]!)!
                let name = row["identifier"]!
                let move = Moves(name: name, movesID: moveId)
                movesArray.append(move) //this holds every move in the csv file.
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    
}
