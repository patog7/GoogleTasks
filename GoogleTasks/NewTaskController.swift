//
//  NewTaskController.swift
//  GoogleTasks
//
//  Created by Patricio González on 5/2/15.
//  Copyright (c) 2015 Patricio Gonz&#225;lez. All rights reserved.
//

import UIKit
import MaterialKit
import Foundation
import SwiftyJSON



var demoList = "MTM5OTMyMDA4MTMwNjQ4NDY4NTI6MTA2Njc0OTQ0Nzow"

class NewTaskController: UIViewController {
    
    @IBOutlet weak var newTitle: MKTextField!
    @IBOutlet weak var newDate: MKTextField!
    @IBOutlet weak var newList: MKTextField!
    @IBOutlet weak var newNotes: MKTextField!
    @IBOutlet weak var delete: MKButton!
    
    @IBAction func acept(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let temptask = Task()
        
        temptask.list = demoList
        temptask.title = newTitle.text
        temptask.notes = newNotes.text
        if( newDate.text != nil){
            temptask.due = newDate.text
        }else{
            temptask.due = ""
        }
        
        println("TITLE!: \(temptask.title)")
        
        let url = NSURL(string: "https://www.googleapis.com/tasks/v1/lists/\(demoList)/tasks/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        let bodystring = "{\n \"title\": \"\(temptask.title)\"\n}"
        
        let body = (bodystring as NSString).dataUsingEncoding(NSUTF8StringEncoding)


        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        if data != nil {
            var hoge = JSON(data: data!)
//                                println("Hoge solo:\n\(hoge.count)\n")
//                                println("- - - - - - - - - - -")
//                                println(hoge["items"])
//                                println("- - - - - - - - - - -")
//            for (key: String, subJson: JSON) in hoge["items"] {
//                idlistas.append(subJson["id"].string!)
//                nombrelistas.append(subJson["title"].string!)
//            }
        }
        
        
//        let bodystring = "{ \"title\": \"\(temptask.title)\",\"notes\": \"\(temptask.notes)\" }"
//        
//        let body = (bodystring as NSString).dataUsingEncoding(NSUTF8StringEncoding)
//        request.HTTPBody = body
//        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
        let returnstring = NSString(data: data!, encoding:NSUTF8StringEncoding )
        println("Return: \(returnstring)")
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(edit == true){
            newTitle.text = editTask.title
            for list in lists{
                println("Lista checada: \(list.id) contra \(editTask.list)")
                if (list.id == editTask.list){
                    newList.text = list.title
                }
            }
            newDate.text = editTask.due
            newNotes.text = editTask.notes
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func deleteButton(sender: AnyObject) {
    }
    
    
    
    
//    @IBAction func addNewTask(sender: MKButton) {
//        let temptask = Task()
//        
//        temptask.list = demoList
//        temptask.title = newTitle.text
//        temptask.notes = newNotes.text
//        if( newDate.text != nil){
//            temptask.due = newDate.text
//        }else{
//            temptask.due = ""
//        }
//        
//        
//        let url = NSURL(string: "https://www.googleapis.com/tasks/v1/lists/\(demoList)/tasks/")
//        let request = NSMutableURLRequest(URL: url!)
//        request.HTTPMethod = "PUT"
//        
//        let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("mainList") as! ViewController
//        let token = viewController.token
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        let bodystring = "{ \"title\": \"\(temptask.title)\",\"notes\": \"\(temptask.notes)\" }"
//        
//        let body = (bodystring as NSString).dataUsingEncoding(NSUTF8StringEncoding)
//        request.HTTPBody = body
//        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
//        println("SE MANDÓ ESTO: \(data)")
//
//        self.navigationController?.popViewControllerAnimated(true)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         Get the new view controller using segue.destinationViewController.
//         Pass the selected object to the new view controller.
        
    }
    */


}
