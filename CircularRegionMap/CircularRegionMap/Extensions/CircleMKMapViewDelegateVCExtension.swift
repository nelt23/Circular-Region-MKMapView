//
//  CircleMKMapViewDelegateVCExtension.swift
//  CircularRegionMap
//
//  Created by Nuno Martins on 02/02/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import MapKit

extension CircularRegionMapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        CircularRegionMapVC.pulsatingLayer.RemovedPulsatingLayer()
        
        if displayLink == nil {
            let displayLink = CADisplayLink(target: self, selector: #selector(self.RunLoopIncreaseCircleDotRadius))
            displayLink.add(to: RunLoop.current, forMode: .common)
            displayLink.preferredFramesPerSecond = 30
            self.displayLink = displayLink
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // desligar o update frames
        displayLink?.invalidate()
        displayLink = nil
    }
    
}
