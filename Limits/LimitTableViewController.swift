//
//  LimitTableViewController.swift
//  Limits
//
//  Created by Michael Epstein on 3/13/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftlySalesforce
import BRYXBanner

class LimitTableViewController: UITableViewController {

	// View model
	private var viewModel: LimitTableViewModel?
	
	// Formatter for timestamp showing last load date/time
	private let timestampFormatter = NSDateFormatter.timestampFormatter()

	// Outlets
	@IBOutlet weak var statusLabel: UIBarButtonItem!
	@IBOutlet weak var refreshButton: UIBarButtonItem!
	@IBOutlet weak var filterSegment: UISegmentedControl!
	
	private var updating: Bool = false {
		
		didSet {
			
			if updating {
				statusLabel.title = "Updating..."
				refreshButton.enabled = false
			}
			else {
				tableView.reloadData()
				refreshControl?.endRefreshing()
				refreshButton.enabled = true
				if let timestamp = Model.sharedInstance.limitCache.timestamp {
					statusLabel.title = "Updated: \(timestampFormatter.stringFromDate(timestamp))"
				}
				else {
					statusLabel.title = ""
				}
				
				// Update segment control
				// TODO: localize
				filterSegment.setTitle("All (\(viewModel?.table(stateFilter: nil).totalRows ?? 0))", forSegmentAtIndex: 0)
				filterSegment.setTitle("High (\(viewModel?.table(stateFilter: .High).totalRows ?? 0))", forSegmentAtIndex: 1)
				filterSegment.setTitle("Med. (\(viewModel?.table(stateFilter: .Medium).totalRows ?? 0))", forSegmentAtIndex: 2)
				filterSegment.setTitle("Low (\(viewModel?.table(stateFilter: .Low).totalRows ?? 0))", forSegmentAtIndex: 3)
			}
		}
	}

	private var table: LimitTableViewModel.Table? {
		guard let viewModel = viewModel else {
			return nil
		}
		switch filterSegment.selectedSegmentIndex {
		case 1:
			return viewModel.table(stateFilter: .High)
		case 2:
			return viewModel.table(stateFilter: .Medium)
		case 3:
			return viewModel.table(stateFilter: .Low)
		default:
			return viewModel.table(stateFilter: nil)
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.refreshControl?.addTarget(self, action: #selector(LimitTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if Model.sharedInstance.limitCache.isEmpty || Model.sharedInstance.siteCache.isEmpty {
			refresh()
		}
	}
	
	func refresh() {
		updating = true
		when(Model.sharedInstance.limitCache.refresh(), Model.sharedInstance.siteCache.refresh()).then {
			() -> () in
			let orgLimits = Model.sharedInstance.limitCache.data ?? [Limit]()
			let sites = Model.sharedInstance.siteCache.data ?? [Site]()
			self.viewModel = LimitTableViewModel(orgLimits: orgLimits, sites: sites)
			self.updating = false
		}.error {
			(error) -> () in
			if case let PromiseKit.Error.When(_, err) = error {
				Banner(error: err, title: "Error loading limits") {
					self.updating = false
				}.show(duration: 3.0)
			}
		}
	}
	
	func handleRefresh(refreshControl: UIRefreshControl) {
		refresh()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let cell = sender as? LimitTableViewCell, vc = segue.destinationViewController as? LimitDetailViewController {
			vc.limit = cell.limit
		}
	}
	
	// Unwind segue
	@IBAction func unwind(segue: UIStoryboardSegue) {
		if let ip = tableView.indexPathForSelectedRow {
			tableView.deselectRowAtIndexPath(ip, animated: true)
		}
	}
	
	// Unwind & log out segue
	@IBAction func unwindAndLogOut(segue: UIStoryboardSegue) {
		updating = true
		if let app = UIApplication.sharedApplication().delegate as? LoginViewPresentable {
			app.logOut().then {
				() -> () in
				Model.sharedInstance.clear()
				UIApplication.sharedApplication().applicationIconBadgeNumber = 0
				self.updating = false
			}.error {
				(error) -> () in
				Banner(error: error, title: "Error logging out") {
					self.updating = false
				}.show(duration: 3.0)
			}
		}
	}
	
	@IBAction func refreshButtonTapped(sender: AnyObject) {
		refresh()
	}

	@IBAction func filterValueChanged(sender: AnyObject) {
		tableView.reloadData()
	}
	
	// MARK: - Table view data source

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return table?.sections.count ?? 0
	}
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table?.sections[section].rows.count ?? 0
    }

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("LimitCell", forIndexPath: indexPath)
		if let limitCell = cell as? LimitTableViewCell, limit = table?.sections[indexPath.section].rows[indexPath.row] {
			limitCell.limit = limit
		}
        return cell
    }
	
	override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return table?.sections[section].label
	}
	
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if let siteCount = Model.sharedInstance.siteCache.data?.count where siteCount > 0 {
			return 44.0
		}
		else {
			return 0.0
		}
	}
}
