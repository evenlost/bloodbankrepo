//
//  ViewController.swift
//  bloodapp
//
//  Created by HOME on 7/18/17.
//  Copyright © 2017 HOME. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var plusbtn: UIBarButtonItem!
    
    
    var task: [Bloodbank] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredtask = [Bloodbank]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self       //Delegates can be used to define callback methods.and allows method to be passed as parameter.
        
        
        filteredtask = task
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        table.tableHeaderView = searchController.searchBar
        
        
    //    self.table.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        
        

               // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredtask = task
        } else {
            // Filter the results
            filteredtask = task.filter { ($0.name?.lowercased().contains(searchController.searchBar.text!.lowercased()))! }
            
            for i in 0..<filteredtask.count  {
                print(String(describing: String(i)+" "+filteredtask[i].name!));
            }
            
        }
        
        self.table.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        //get the data from coredata
        getdata()
        
        
        //reload the table view
        table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredtask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //code to print in custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let newtask = filteredtask[indexPath.row]
        
        
        //print in custom cell
        cell.cellname?.text = newtask.name
        cell.cellbgroup?.text = newtask.blood
        cell.cellcontact?.text = String (newtask.contact)
        cell.cellsn?.text = String(describing: indexPath.row + 1)
        
        //print bgcolor in cell
        cell.contentView.backgroundColor = ((indexPath.row%2)==0) ? UIColor.blue : UIColor.green
        
        
        
    //to print in table view not in custom cell
//        let cell = UITableViewCell()
//        
//        
//        let newtask = filteredtask[indexPath.row]
//        
//        
//            cell.textLabel?.text = String(describing:indexPath.row + 1) + "  " + newtask.name! + "  " + newtask.blood! + "  " + String(newtask.contact)
        
        return cell
    }
    
    
    //fetching the data
    func getdata() {
        
        let contex =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do{
            task = try contex.fetch(Bloodbank.fetchRequest())
            filteredtask = task
        }
        catch {
            print("fetching failed")
        }
        
    }

    //delete the item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let contex =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let task = filteredtask[indexPath.row]
            contex.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do{
                filteredtask = try contex.fetch(Bloodbank.fetchRequest())
            }
            catch {
                print("fetching failed")
            }
        }
        table.reloadData()
        
        
    }
    
    //perform segue
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "onesegue", sender: indexPath)
    }
    
//transfer data from one segue to another (prepare for segue)
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onesegue" {         //onesegue is identifier
            if let toViewController = segue.destination as? addViewController
            {
                
                if let indexPath = sender as? IndexPath {
                     toViewController.bloodbank = filteredtask[indexPath.row]
                }
               
            }
        }
        
    }
}
