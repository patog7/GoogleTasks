//
//  ViewController.swift
//  GoogleTasks
//
//  Created by Patricio González on 3/9/15.
//  Copyright (c) 2015 Patricio González. All rights reserved.
//

import UIKit
import MaterialKit
import Foundation
import SwiftyJSON

public var editTask: Task!
public var edit = false
public var lists : [List] = []



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskCellDelegate, GPPSignInDelegate {
    
    @IBOutlet weak var TaskTable: UITableView!
    
    @IBAction func addButton(sender: AnyObject) {
    }

    @IBOutlet weak var addButton: MKButton!
    
    
    var signIn : GPPSignIn!
//    var lists = Array<Array<String>>()
    var tareas = [String]()
    var fecha = [String]()
    var refreshControl:UIRefreshControl!
    
    var tasks : [Task] = []
    
    var idlistas = [String]()
    var nombrelistas = [String]()
    
    var colores = ["Tarea Número 1","Tarea Número Dos", "Tarea Tres","Ir por la tintoreria"]
    var detalle = ["El azul es vida","El morado", "El rojo","El amarillo"]
//    var checks = [true, false, false, false, false, true, false, false]

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.tasks.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as! TasksCell
        
        // Configure the cell...
        
        cell.TaskCellToggle.layer.cornerRadius = 36.0
        cell.task = self.tasks[indexPath.row]
        cell.TaskTitle.text = self.tasks[indexPath.row].title
        cell.TaskDetail.text = self.tasks[indexPath.row].due
        cell.delegate = self
        cell.indexPath = indexPath
        cell.checkstatus=self.tasks[indexPath.row].status
        if (cell.checkstatus == true) {
            cell.TaskCheck.image = UIImage(named: "check-box-outline")
        } else {
            cell.TaskCheck.image = UIImage(named: "check-box-outline-blank")
        }
        
        self.view.bringSubviewToFront(addButton)

        cell.updateConstraints()
        return cell
    }
    
    
    func didSelectCheckButtonAtIndexPath(indexPath: NSIndexPath) {
        let cell = self.TaskTable.cellForRowAtIndexPath(indexPath) as! TasksCell

        if (cell.checkstatus==true){
            cell.checkstatus=false

            let url = NSURL(string: "https://www.googleapis.com/tasks/v1/lists/\(tasks[indexPath.row].list)/tasks/\(tasks[indexPath.row].id)")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "PATCH"
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
            let bodystring = "{ \"status\": \"needsAction\" }"
            let body = (bodystring as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = body
            var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            let returnstring = NSString(data: data!, encoding:NSUTF8StringEncoding )
            println("Return: \(returnstring)")
            cell.TaskCheck.image = UIImage(named: "check-box-outline-blank")
            println(request)
        }

            
        else{
            cell.checkstatus=true
            let url = NSURL(string: "https://www.googleapis.com/tasks/v1/lists/\(tasks[indexPath.row].list)/tasks/\(tasks[indexPath.row].id)")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "PATCH"
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
            let bodystring = "{ \"status\": \"completed\" }"
            let body = (bodystring as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = body
            var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            let returnstring = NSString(data: data!, encoding:NSUTF8StringEncoding )
            println("Return: \(returnstring)")
            cell.TaskCheck.image = UIImage(named: "check-box-outline")
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        self.TaskTable.delegate = self
        self.TaskTable.dataSource = self
        self.TaskTable.rowHeight = UITableViewAutomaticDimension
        self.TaskTable.estimatedRowHeight = 71
        
        
        
        populateTasks()
        
    }
    
    
    
    
    
    func populateTasks(){
        println ("TOKEN! -> \(token!)")
        
        let url = NSURL(string: "https://www.googleapis.com/tasks/v1/users/@me/lists" )
        //                let token = auth.accessToken
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        if data != nil {
            var hoge = JSON(data: data!)
//                                println("Hoge solo:\n\(hoge.count)\n")
//                                println("- - - - - - - - - - -")
//                                println(hoge["items"])
//                                println("- - - - - - - - - - -")
            for (key: String, subJson: JSON) in hoge["items"] {
                idlistas.append(subJson["id"].string!)
                nombrelistas.append(subJson["title"].string!)
                
                let templist = List()
                templist.id = subJson["id"].string!
                templist.title = subJson["title"].string!
                templist.selfLink = subJson["selfLink"].string!
                templist.updated = subJson["updated"].string!
                lists.append(templist)
                
                
            }
            
            println("LISTAS! \(idlistas)")
            
            var listcount=0;
            for lista in idlistas {
                let urlstring = "https://www.googleapis.com/tasks/v1/lists/" + lista + "/tasks"
                let url = NSURL(string: urlstring )
                //                        let token = auth.accessToken
                let request = NSMutableURLRequest(URL: url!)
                request.HTTPMethod = "GET"
                request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
                var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
                if data != nil {
                    hoge = JSON(data: data!)
                    println(hoge["items"])
                    //                            var tareas = [String]()
                    println("\n- - - LIST ID BONITO - - -")
                    println(lista)
                    println()
                    
                    println("- - - TASKS - - -")
                    for (key: String, subJson: JSON) in hoge["items"] {
                        
                        let temptask = Task()
                        temptask.list = lista
                        temptask.id = subJson["id"].string!
                        temptask.etag = subJson["etag"].string!
                        temptask.title = subJson["title"].string!
                        temptask.updated = subJson["updated"].string!
                        temptask.selfLink = subJson["selfLink"].string!
                        temptask.position = subJson["position"].string!
                        if(subJson["notes"] != nil){
                            temptask.notes = subJson["notes"].string!
                        }
                        if(subJson["status"] == "completed"){
                            temptask.status = true
                        }
                        
                        if(subJson["due"] != nil){
                            temptask.due = subJson["due"].string!
                        }
                        
                        if(subJson["completed"] != nil){
                            temptask.completed = subJson["completed"].string!
                        }
                        
                        if(subJson["deleted"] != nil){
                            temptask.deleted = true
                        }
//                        temptask.deleted = subJson["deleted"].bool!


                        tasks.append(temptask)
                        
                        
                        //                                println(subJson["title"].string!)
                        //                                nombreTareas.append(subJson["title"].string!)
                        
                        //                                lists[listcount] = [lista]
                    }
                    //                            lists[listcount]=tareas
//                    println("LISTCOUNT: \(lists)")
                }
            }
            
        }
    
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //Pasar renglón a la forma!!!
        // Create a variable that you want to send
        
        if segue.identifier == "editSegue" {
            var editCell = TaskTable.cellForRowAtIndexPath(TaskTable.indexPathForSelectedRow()!) as! TasksCell
            editTask = editCell.task
            edit = true
        } else{
            edit = false
        }
        
        
    }
    
    
    @IBAction func signOut(sender: AnyObject) {
            //Create the AlertController
            let actionSheetController: UIAlertController = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .ActionSheet)
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Sign Out", style: .Destructive) { action -> Void in
                //Code for launching the camera goes here
                self.performSegueWithIdentifier("signOutSegue", sender: self)
                self.signIn.signOut()
            }
            actionSheetController.addAction(takePictureAction)
            
            //We need to provide a popover sourceView when using it on iPad
            actionSheetController.popoverPresentationController?.sourceView = sender as! UIView;
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error != nil{
            println ("error! -> \(error)")
        }
        
    }


}

