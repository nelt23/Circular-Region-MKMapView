//
//  CircleDisplayLinkExtension.swift
//  CircularRegionMap
//
//  Created by Nuno Martins on 02/02/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import Foundation

// Para sincronizar os frames
extension CircularRegionMapVC {
    
    @objc func RunLoopIncreaseCircleInternRadius() {
        
        let circleBothClass = CircleBoth(mapView: MapView, circleCoordinate: circleCoordinate, circleRadius: circleRadius)
        
        if SegmentControlCircle.selectedSegmentIndex == 0 {
            
            let circleInternClass = CircleIntern(mapView: MapView, circleBothClass: circleBothClass, circleInternCoordinate: circleCoordinate, circleInternRadius: circleRadius)
            
            circleInternClass.FuncCreateCircles(circleInternCoordinate: circleCoordinate, circleInternRadius: circleRadius, PositionTheMap: false)
            
        } else {
            let circleExternClass = CircleExtern(mapView: MapView, circleBothClass: circleBothClass, circlePolygonExternCoordinate: circleCoordinate, circlePolygonExternRadius: circleRadius)
            
            circleExternClass.FuncCreateCircles(circlePolygonExternCoordinate: circleCoordinate, circlePolygonExternRadius: circleRadius, PositionTheMap: false)
        }
        
        let circleDotCoordinate = circleBothClass.FuncCircleDotCoordinate(circleCoordinate: circleCoordinate, circleRadius: circleRadius)
        
        FuncRadiusText (circleCoordinate: circleCoordinate, circleDotCoordinate: circleDotCoordinate)
        
        // chama os did e o will do mapview para parar o displayFrames
        MapView.delegate = self
    }
    
    
    @objc func RunLoopIncreaseCircleDotRadius() {
        
        let circleBothClass = CircleBoth(mapView: MapView, circleCoordinate: circleCoordinate, circleRadius: circleRadius)
        
        let circleDotCoordinate = circleBothClass.FuncCircleDotCoordinate(circleCoordinate: circleCoordinate, circleRadius: circleRadius)
        let circleDotRadius = MapView.FuncCircleDotRadiusZoom(mapView: MapView)
        
        circleBothClass.FuncCreateCircleDot(circleDotCoordinate: circleDotCoordinate, circleDotRadius: circleDotRadius)
        
        // chama os will e o did do mapView para parar o displayFrames
        MapView.delegate = self
    }
    
}
