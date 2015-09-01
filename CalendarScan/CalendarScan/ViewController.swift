//
//  ViewController.swift
//  CalendarScan
//
//  Created by Alexander on 21/05/15.
//  Copyright (c) 2015 marsbroshok. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var parser:TextParser?
    var entities = [String:[String]]()

    
    @IBOutlet weak var entitiesTable: UITableView!
    
    private let sampleText = "Café Lomi is another fantastic Franco-Australian collaboration. Together, French owner Aleaume Paturle and Aussie barista Paul Arnephy have created a spacious neighborhood hub on 3 Rue Marcadet in the 18th Arrondissement. Don’t let the café’s location fool you: the interior is cozy and tastefully furnished. And oh yeah, then there’s the coffee! All exclusively selected beans are roasted on site, and both the filter coffee and espresso blend are truly incredible."
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialization of TextParser will take a long time, so we should NOT run it in the main thread
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
        dispatch_async(queue, {
            dispatch_sync(queue, {
                self.parser = TextParser()
            })
            dispatch_sync(dispatch_get_main_queue(), {
                self.removeActivityViewController()
            })
        })
        
        let activityVC = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("ActivityVC") 
        self.presentViewController(activityVC, animated: false, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        let calendars = UserCalendars()
        var eventRawText = ""
        calendars.getCalendarEvents()
        if calendars.rawEvents.count != 0
        {
            for event:EventEntity in calendars.rawEvents {
                print("Raw Events: \(event.date) - \(event.rawText)")
                eventRawText += event.rawText
            }
            entities = self.parser!.iOSfindNamedEntitiesForText(eventRawText)

        }
        else
        {
            entities = self.parser!.iOSfindNamedEntitiesForText(sampleText)
        }
        print(entities)
        self.entitiesTable.reloadData()
    }
    
    @IBAction func mitieButtonPressed(sender: UIButton) {
        let calendars = UserCalendars()
        var eventRawText = ""
        calendars.getCalendarEvents()
        if calendars.rawEvents.count != 0
        {
            for event:EventEntity in calendars.rawEvents {
                print("Raw Events: \(event.date) - \(event.rawText)")
                eventRawText += event.rawText
            }
            entities = self.parser!.findNamedEntitesForText(eventRawText)

        }
        else
        {
            entities = self.parser!.findNamedEntitesForText(sampleText)
        }
        print(entities)
        self.entitiesTable.reloadData()

    }
   
    func removeActivityViewController() {
        self.presentedViewController?.dismissViewControllerAnimated(true, completion: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        let alert = UIAlertController(title: "Calendar Scan", message: "Please, use buttons below to choose iOS Text Scanner or Custom Text Scanner.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let sectionNumber:Int = entities.count
        return sectionNumber

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let values = Array(entities.values)
        let rowsNumber = values[section].count
        return rowsNumber
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("entityCell", forIndexPath: indexPath) 
        let values = Array(entities.values)[indexPath.section]
        let entity = values[indexPath.row]
        cell.textLabel!.text = "\(entity)"
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "  \(Array(entities.keys)[section])"
        label.backgroundColor = UIColor.clearColor()
        label.sizeToFit()
        return label
    }


}

