//
//  CircleGestureExtension.swift
//  CircularRegionMap
//
//  Created by Nuno Martins on 26/01/2019.
//  Copyright © 2019 Nuno Martins. All rights reserved.
//

import MapKit

extension CircularRegionMapVC: UIGestureRecognizerDelegate {
    
    // should be allowed to recognize gestures simultaneously
    func gestureRecognizer (_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func CircleDotPressGesture (_ gesture: UILongPressGestureRecognizer) {
    }
    
    @objc func CircleDotPanGesture (_ gesture: UIPanGestureRecognizer) {
        
        if (gesture.state == .began) {

            radiusText.isHidden = false

            CircularRegionMapVC.radiusCircleInternInMKMapPointGesture = MKMapPointsPerMeterAtLatitude(circleCoordinate.latitude)*circleRadius
            
            CircularRegionMapVC.pulsatingLayer.RemovedPulsatingLayer()
        }

        var circleInternTangentPoint = CGPoint()

        let circleInternPoint = MKMapPoint(circleCoordinate)
        
        circleInternTangentPoint.x = CGFloat(circleInternPoint.x) + CGFloat(CircularRegionMapVC.radiusCircleInternInMKMapPointGesture)
        circleInternTangentPoint.y = CGFloat(circleInternPoint.y)
        
        let circleInternTangentMKMapPoint = MKMapPoint(x: Double(circleInternTangentPoint.x), y: Double(circleInternTangentPoint.y))
        circleDotCoordinate = circleInternTangentMKMapPoint.coordinate
        
        // Translação provocada pelo dedo
        var translation = gesture.translation(in: nil)
        
        // Caso o nosso dedo mova-se para a esquerda e o raio seja menor que 100m
        if translation.x < 0.0 && (round(circleRadius/10)*10 <= 100) {

            circleDotCoordinate = FuncBlockCircleRadius(BlockRadius: 100)
            translation.x = 0.0
            
        // Caso o nosso dedo mova-se para a direita e o raio seja maior que 1000km
        } else if translation.x > 0.0 && (round(circleRadius/10)*10 >= (1000*1000)) {

            circleDotCoordinate = FuncBlockCircleRadius(BlockRadius: 1000*1000)
            translation.x = 0.0
            
        // Se a translação ocorrer muito depressa existe ainda a hipotese de o increase radius ocorrer pelo lado esquerdo
        // Verificar se o raio é maior que 100m e se a coordenadas do screen do Circle Dot sao mais à esquerda que as coordenadas do Circle
        } else if (round(circleRadius/10)*10 > 100) && ((MapView.convert(circleDotCoordinate, toPointTo: nil).x + translation.x) < MapView.convert(circleCoordinate, toPointTo: nil).x) {

            circleDotCoordinate = FuncBlockCircleRadius(BlockRadius: 100)
            translation.x = 0.0
        }
        
        // CGPoint do centro do novo Dot com translação
        let circleDotPoint = CGPoint(x: MapView.convert(circleDotCoordinate, toPointTo: nil).x + translation.x, y: MapView.convert(circleDotCoordinate, toPointTo: nil).y)
        
        // como estamos a usar valores de diferentes views um do translation (view) e outro do mapView
        let newCircleDotCoordenate = MapView.convert(circleDotPoint, toCoordinateFrom: nil)
        
        // Distancia em metros correspondente ao radius do Circle
        circleRadius = circleInternPoint.distance(to: MKMapPoint(newCircleDotCoordenate))
                
        // Verificar se displayLink ja tem um run loop
        if displayLink == nil {
            let displayLink = CADisplayLink(target: self, selector: #selector(self.RunLoopIncreaseCircleInternRadius))
            displayLink.add(to: RunLoop.current, forMode: .common)
            displayLink.preferredFramesPerSecond = 10
            self.displayLink = displayLink
        }
        
        // CGFloat posição do novo Dot
        let BoundsViewCheck = MapView.convert(circleDotCoordinate, toPointTo: nil).x + translation.x
        
        // Caso o nosso dedo chegue ou ultrapasse as margens da tela
        if BoundsViewCheck >= self.view.bounds.width {
            displayLink?.invalidate()
            displayLink = nil
        }
        
        
        if (gesture.state == .ended) || (gesture.state == .cancelled) || (gesture.state == .failed) {
            
            displayLink?.invalidate()
            displayLink = nil
            
            radiusText.isHidden = true

            let circleBothClass = CircleBoth(mapView: MapView, circleCoordinate: circleCoordinate, circleRadius: circleRadius)

            if SegmentControlCircle.selectedSegmentIndex == 0 {
                
                let circleInternClass = CircleIntern(mapView: MapView, circleBothClass: circleBothClass, circleInternCoordinate: circleCoordinate, circleInternRadius: circleRadius)
                circleInternClass.FuncCreateCircles(circleInternCoordinate: circleCoordinate, circleInternRadius: circleRadius, PositionTheMap: true)
            } else {
                
                let circleExternClass = CircleExtern(mapView: MapView, circleBothClass: circleBothClass, circlePolygonExternCoordinate: circleCoordinate, circlePolygonExternRadius: circleRadius)
                circleExternClass.FuncCreateCircles(circlePolygonExternCoordinate: circleCoordinate, circlePolygonExternRadius: circleRadius, PositionTheMap: true)
            }
            
            let circleDotCoordinateUpdate = circleBothClass.FuncCircleDotCoordinate(circleCoordinate: circleCoordinate, circleRadius: circleRadius)

            CircularRegionMapVC.pulsatingLayer.AnimatedLayer(view: view, mapView: MapView, circleCoordinate: circleCoordinate, circleDotCoordinate: circleDotCoordinateUpdate, circleDotRadius: MapView.FuncCircleDotRadiusZoom(mapView: MapView))
        }
        
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let touchPointScreen = touch.location(in: nil)
        
        // como estamos a usar valores de difentes views um do translation (view) e outro do map
        let TouchInCoordenate = MapView.convert(touchPointScreen, toCoordinateFrom: nil)
        let TouchInMKMapPoint = MKMapPoint(TouchInCoordenate)
        
        // Assim que recebe o toque chamar o did e o will
        MapView.delegate = self
        
        for overlay in MapView.overlays {
            
            if let circle = overlay as? MKCircle {
                
                if circle.radius == MapView.FuncCircleDotRadiusZoom(mapView: MapView) {
                    
                    let centerCircle = MKMapPoint(circle.coordinate)
                    let radiusCircle = centerCircle.distance(to: TouchInMKMapPoint)
                    
                    if radiusCircle < circle.radius*2.5 {
                        
                        // Aqui como queremos que o mapa fico parado logo o delegate tem que ser nil fixando assim o mapView
                        self.pressGesture.delegate = nil
                        return true
                    } else {
                        // Aqui como queremos que o mapa mexa logo o delegate tem que ser self mexendo assim o mapView
                        self.pressGesture.delegate = self
                    }
                    
                }
                
            }
            
        }
        
        return false
    }
    
}
