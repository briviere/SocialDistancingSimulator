//
//  CovidGraphView.swift
//  CovidGraph
//
//  Created by Chris Morris on 3/23/20.
//  Copyright © 2020 Chris Morris. All rights reserved.
//

import UIKit

class SimulatorGraphView: UIView {

    // MARK: - Constants

    enum Constants {
        static let graphBackgroundColor = UIColor(named: "graphBackgroundColor")!
    }

    // MARK: - Private Variables

    private var totalModeledTime: Int = 604 {
        didSet {
            setNeedsDisplay()
        }
    }
    private var snapshots: [GraphSnapshot] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: - Public Variables

    func reset() {
        snapshots = []
    }

    func updateWith(snapshot: GraphSnapshot) {
        snapshots.append(snapshot)
    }

    // MARK: - UIView / Graph Drawing

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let widthPerSnapshot = bounds.width / CGFloat(totalModeledTime)
        
        
        for (index, snapshot) in snapshots.enumerated() {
            let recoveredRect = CGRect(x: CGFloat(index) * widthPerSnapshot,
                                       y: 0,
                                       width: widthPerSnapshot,
                                       height: CGFloat(snapshot.recoveredPercentage) * bounds.height)
            let healthyRect = CGRect(x: recoveredRect.minX,
                                     y: recoveredRect.maxY,
                                     width: recoveredRect.width,
                                     height: CGFloat(snapshot.healthyPercentage) * bounds.height)
            let sickRect = CGRect(x: healthyRect.minX,
                                  y: healthyRect.maxY,
                                  width: healthyRect.width,
                                  height: CGFloat(snapshot.sickPercentage) * bounds.height)
            
            UIColor.blue.setFill()
            context.fill(recoveredRect)
            
            Constants.graphBackgroundColor.setFill()
            context.fill(healthyRect)
            
            UIColor.red.setFill()
            context.fill(sickRect)
        }
    }
}
