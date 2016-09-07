//
//  LimitTableViewModel.swift
//  Limits
//
//  Created by Michael Epstein on 7/5/16.
//  Copyright © 2016 Michael Epstein. All rights reserved.
//

import Foundation

internal struct LimitTableViewModel {
	
	// MARK: - Struct definitions
	
	struct Section {
		let label: String
		let rows: [Limit]
	}
	
	struct Table {
		let sections: [Section]
		var totalRows: Int {
			var n = 0
			for section in sections {
				n += section.rows.count
			}
			return n
		}
	}
	
	// MARK: -
	
	private let allLimits: Table
	private let highLimits: Table
	private let mediumLimits: Table
	private let lowLimits: Table
	
	// Closure used to filter allLimits into other tables by limit state
	private let filter: (Table, Limit.LimitState) -> Table = {
		(table, state) -> Table in
		var sections = [Section]()
		for section in table.sections {
			let rows = section.rows.filter { $0.state == state }
			if rows.count > 0 {
				sections.append(Section(label: section.label, rows: rows))
			}
		}
		return Table(sections: sections)
	}
	
	init(orgLimits: [Limit], sites: [Site]) {
				
		// All limits, grouped by sections of "org-wide" limits, and a section for each Force.com Site
		var sections = [ Section(label: "Org Limits", rows: orgLimits) ] //TODO: localize
		for site in sites {
			let label = "\(site.masterLabel) (\(site.name))"
			sections.append(Section(label: label, rows: [site.dailyBandwidthLimit, site.dailyRequestTimeLimit]))
		}
		allLimits = Table(sections: sections)
		highLimits = filter(allLimits, Limit.LimitState.High)
		mediumLimits = filter(allLimits, Limit.LimitState.Medium)
		lowLimits = filter(allLimits, Limit.LimitState.Low)
	}
	
	func table(stateFilter stateFilter: Limit.LimitState?) -> Table {
		if let state = stateFilter where state == .High {
			return highLimits
		}
		else if let state = stateFilter where state == .Medium {
			return mediumLimits
		}
		else if let state = stateFilter where state == .Low {
			return lowLimits
		}
		else {
			return allLimits
		}
	}
}