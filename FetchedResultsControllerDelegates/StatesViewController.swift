//
//  StatesViewController.swift
//  FetchedResultsControllerDelegates
//
//  Created by Mazharul Huq on 3/2/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class StatesViewController: UITableViewController {

    var coreDataStack = CoreDataStack(modelName: "States")
    var managedContext:NSManagedObjectContext!
    var tapCount = 0
    
    lazy var fetchedResultsController:NSFetchedResultsController<State> = {
        //1 Creating fetch request and adding sort descriptor
        let fetchRequest:NSFetchRequest<State> = State.fetchRequest()
        let sort1 = NSSortDescriptor(key: #keyPath(State.firstLetter), ascending: true)
        let sort2 = NSSortDescriptor(key: #keyPath(State.visitCount), ascending: false)
        fetchRequest.sortDescriptors = [sort1,sort2]
        
        //2 Creating an instance of NSFetchedResultsController
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataStack.managedContext, sectionNameKeyPath: #keyPath(State.firstLetter), cacheName: nil)
        
        //3 Assigning delegate
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80.0
        self.managedContext = self.fetchedResultsController.managedObjectContext
        do{
            try self.fetchedResultsController.performFetch()
        }
        catch{
            let fetchError = error as NSError
            print("Unable to fetch \(fetchError),(fetchError.userInfo)")
        }
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.fetchedResultsController.sections else{
            return 0
        }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else
        {
            return 0
        }
        let sectionInfo = sections[section]
        print(sectionInfo.numberOfObjects)
        return sectionInfo.numberOfObjects
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(_ cell: MyTableViewCell, indexPath: IndexPath) {
        
        let state = fetchedResultsController.object(at: indexPath)
        cell.stateLabel.text = state.name
        cell.countLabel.text = "#Visited: \(state.visitCount)"
        
        if let image = UIImage(named: state.flag!){
            print("Here")
            cell.stateImage.image = image
        }
    }
    
    
    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let state = fetchedResultsController.object(at: indexPath)
        state.visitCount += 1
        coreDataStack.saveContext()
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = self.fetchedResultsController.object(at: indexPath)
            self.managedContext.delete(person)
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error),\(error.userInfo)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int)
        -> String? {
            let sectionInfo = fetchedResultsController.sections?[section]
            return sectionInfo?.name
    }
}

// MARK: -NSFetchedRecordsController delegate methods

extension StatesViewController:NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!],with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!],with: .automatic)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!)as UITableViewCell!
            configureCell(cell! as! MyTableViewCell, indexPath: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!],with: .automatic)
            tableView.insertRows(at: [newIndexPath!],with: .automatic)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet,with: .automatic)
        case .delete:
            tableView.deleteSections(indexSet,with: .automatic)
        default :
            break
        }
    }
}

