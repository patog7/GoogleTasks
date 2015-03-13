//
//  ViewController.swift
//  GoogleTasks
//
//  Created by Patricio González on 3/9/15.
//  Copyright (c) 2015 Patricio González. All rights reserved.
//

import UIKit
import MaterialKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskCellDelegate {
    
    @IBOutlet weak var TaskTable: UITableView!

    var colores = ["Tarea Número 1","Tarea Número Dos", "Tarea Tres","Ir por la tintoreria"]
    var detalle = ["El azul es vida","El morado", "El rojo","El amarillo"]
    var checks = [true, false, false, false]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.colores.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as TasksCell
        
        // Configure the cell...
        
        cell.TaskCellToggle.layer.cornerRadius = 36.0
        
        cell.TaskTitle.text = self.colores[indexPath.row]
        //        cell.imagenColor.layer.cornerRadius = cell.imagenColor.frame.size.width/2
        //        cell.imagenColor.clipsToBounds = true
        
        cell.TaskDetail.text = self.detalle[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        cell.checkstatus=self.checks[indexPath.row]
        if (cell.checkstatus == true) {
            cell.TaskCheck.image = UIImage(named: "check-box-outline")
        } else {
            cell.TaskCheck.image = UIImage(named: "check-box-outline-blank")
        }

        return cell
    }
    
    func didSelectCheckButtonAtIndexPath(indexPath: NSIndexPath) {
        let cell = self.TaskTable.cellForRowAtIndexPath(indexPath) as TasksCell

        if (cell.checkstatus==true){
            cell.checkstatus=false
            cell.TaskCheck.image = UIImage(named: "check-box-outline")}
        else{
            cell.checkstatus=true
            cell.TaskCheck.image = UIImage(named: "check-box-outline-blank")
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.TaskTable.delegate = self
        self.TaskTable.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

