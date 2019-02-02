//
//  CircleExtrasFunc.swift
//  CircularRegionMap
//
//  Created by Nuno Martins on 02/02/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import MapKit

extension CircularRegionMapVC {
    
    func FuncBlockCircleRadius(BlockRadius: Double) -> CLLocationCoordinate2D {
        
        let circleInternPoint = MKMapPoint(circleCoordinate)
        
        var circleInternTangentPoint = CGPoint()
        
        // Raidus do Circle com raio de 1000 km
        let radiusCircleInternInMKMapPoint = MKMapPointsPerMeterAtLatitude(circleCoordinate.latitude)*BlockRadius
        
        // CGPoint do centro do Dot com raio de 1000 km
        circleInternTangentPoint.x = CGFloat(circleInternPoint.x) + CGFloat(radiusCircleInternInMKMapPoint)
        circleInternTangentPoint.y = CGFloat(circleInternPoint.y)
        
        // Coordenadas do centro do Dot com raio de 1000 km
        let circleInternTangentMKMapPoint = MKMapPoint(x: Double(circleInternTangentPoint.x), y: Double(circleInternTangentPoint.y))
        
        let circleDotCoordinate = circleInternTangentMKMapPoint.coordinate
        
        return circleDotCoordinate
    }
    
    func FuncRadiusText(circleCoordinate: CLLocationCoordinate2D, circleDotCoordinate: CLLocationCoordinate2D) {
        
        // coordenadas do centro do Dot no ecra
        let circlePointScreen = MapView.convert(circleCoordinate, toPointTo: nil)
        let circleDotPointScreen = MapView.convert(circleDotCoordinate, toPointTo: nil)
        
        let radiusInMKMapPoint = circleDotPointScreen.x-circlePointScreen.x
        
        radiusText.frame = CGRect(x: circlePointScreen.x, y: circlePointScreen.y-25, width: radiusInMKMapPoint, height: 25)
        
        let valueRadius = Int(round(circleRadius/10)*10)
        
        radiusText.text = "\(valueRadius) m"
    }
    
}
