//
//  AppDelegate.swift
//  FetchedResultsControllerDelegates
//
//  Created by Mazharul Huq on 3/2/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(modelName: "States")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        loadStates()
        return true
    }
    
    func loadStates(){
        let fetchRequest:NSFetchRequest<State> = State.fetchRequest()
        var count = 0
        
        do{
            count =
                try self.coreDataStack.managedContext.count(for: fetchRequest)
        }
        catch {
            print("Unable to get person count")
        }
        
        guard count == 0 else{
            print("Here too")
            return
        }
        
        let s = try! String(contentsOfFile: Bundle.main.path(forResource: "states", ofType: "txt")!, encoding: String.Encoding.utf8)
        let states = s.components(separatedBy: "\n")
        
        for stateName in states{
            let state = State(context: self.coreDataStack.managedContext)
            state.name = stateName
            state.firstLetter = getFirstLetter(name: stateName)
            state.flag = getImageFileName(name: stateName)
            state.visitCount = 0
            self.coreDataStack.saveContext()
        }
        
        
    }
    
    func getFirstLetter(name:String)->String{
        guard let first = name.first else{
            return ""
        }
        return String(first)
    }
    
    func getImageFileName(name:String)->String{
        
        var flagName = name.lowercased()
        flagName = flagName.replacingOccurrences(of: " ", with:"")
        flagName = "flag_\(flagName).gif"
        return flagName
    }
    
}

