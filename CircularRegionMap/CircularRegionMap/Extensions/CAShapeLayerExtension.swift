//
//  CircleDotAnimationExtension.swift
//  CircularRegionMap
//
//  Created by Nuno Martins on 27/01/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import MapKit

extension CAShapeLayer : CAAnimationDelegate {
    
    func PulseAnimationOutSideBorders() {
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.fromValue = 1
        animation.toValue = 1.2
        animation.duration = 0.2
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.autoreverses = true
        
        self.add(animation, forKey: "pulsing")
        
    }
    
    func PositionAnimationCenterToTangent(mapView: MKMapView, circleCoordinate: CLLocationCoordinate2D, circleDotCoordinate: CLLocationCoordinate2D) {
        
        let animation = CABasicAnimation(keyPath: "position")
        
        let circlePointScreen = mapView.convert(circleCoordinate, toPointTo: nil)
        let circleDotPointScreen = mapView.convert(circleDotCoordinate, toPointTo: nil)
        
        // para chamar animationDidStop e começar o RemovedPulsatingLayer
        animation.delegate = self
        animation.fromValue = circlePointScreen
        animation.toValue = circleDotPointScreen
        animation.duration = 0.3
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.autoreverses = false

        self.add(animation, forKey: "move")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        RemovedPulsatingLayer()
    }
    
    func RemovedPulsatingLayer() {
        CircularRegionMapVC.pulsatingLayer.removeAllAnimations()
        CircularRegionMapVC.pulsatingLayer.removeFromSuperlayer()
    }
    
    
    func AnimatedLayer(view: UIView, mapView: MKMapView, circleCoordinate: CLLocationCoordinate2D, circleDotCoordinate: CLLocationCoordinate2D, circleDotRadius: Double) {
        
        RemovedPulsatingLayer()

        var circleDotTangentPoint = CGPoint()
        
        // coordenadas do centro do Dot no ecra
        let circleDotPointScreen = mapView.convert(circleDotCoordinate, toPointTo: nil)
        
        // coordenadas do centro do Dot no mapView
        let circleDotPoint = MKMapPoint(circleDotCoordinate)
        
        // Radius do centro do Dot ate ao ponto tangente do Dot
        let radiusCircleDotInMKMapPoint = MKMapPointsPerMeterAtLatitude(circleDotCoordinate.latitude)*circleDotRadius
        
        circleDotTangentPoint.x = CGFloat(circleDotPoint.x) + CGFloat(radiusCircleDotInMKMapPoint)
        circleDotTangentPoint.y = CGFloat(circleDotPoint.y)
        
        let circleDotTangentMKMapPoint = MKMapPoint(x: Double(circleDotTangentPoint.x), y: Double(circleDotTangentPoint.y))
        
        let circleDotTangentCoordenate = circleDotTangentMKMapPoint.coordinate
        
        // Coordenadas do ponto tangente do Dot no ecra
        let circleDotTangentPointScreen = mapView.convert(circleDotTangentCoordenate, toPointTo: nil)
        
        // distancia em modulo entre o centro e o ponto tangente
        let RadiusBezier = abs(circleDotPointScreen.x-circleDotTangentPointScreen.x)
        
        CircularRegionMapVC.pulsatingLayer = CAShapeLayer()
        CircularRegionMapVC.pulsatingLayer.path = UIBezierPath(arcCenter: .zero, radius: RadiusBezier, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        CircularRegionMapVC.pulsatingLayer.fillColor = UIColor.black.cgColor
        CircularRegionMapVC.pulsatingLayer.position = circleDotPointScreen
        view.layer.addSublayer(CircularRegionMapVC.pulsatingLayer)
        
        CircularRegionMapVC.pulsatingLayer.PulseAnimationOutSideBorders()
    }
    
}
