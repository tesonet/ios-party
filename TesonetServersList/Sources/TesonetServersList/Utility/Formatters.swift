//
//  Formatters.swift
//  TesonetServersList
//
//  Created by Vitalii Budnik on 11/6/17.
//  Copyright © 2017 Tesonet. All rights reserved.
//

import Foundation
import MapKit

struct Formatters {
	
	/// Distance formatter.
	static private(set) var distanceFormatter: MKDistanceFormatter = {
		
		let distanceFormatter = MKDistanceFormatter()
		
		distanceFormatter.units = .metric
		distanceFormatter.unitStyle = .abbreviated
		
		return distanceFormatter
		
	}()
	
}
