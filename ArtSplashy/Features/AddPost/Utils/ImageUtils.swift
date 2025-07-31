//
//  ImageUtils.swift
//  ArtSplashy
//
//  Created by Alexandros Theodoropoulos on 05.02.24.
//

import UIKit

struct ImageUtils {
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size // Die ursprüngliche Größe des Bildes

        // Berechnung des Verhältnisses zwischen der Zielgröße und der ursprünglichen Größe
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var scaleFactor: CGFloat
        
        // Bestimmen des kleineren Verhältnisses, um das Bild proportional zu skalieren
        if(widthRatio > heightRatio) {
            scaleFactor = heightRatio
        } else {
            scaleFactor = widthRatio
        }

        // Berechnung der neuen Breite und Höhe basierend auf dem Verhältnis
        let scaledWidth  = size.width * scaleFactor
        let scaledHeight = size.height * scaleFactor

        // Erstellen eines Zielrechtecks mit den skalierten Abmessungen
        let targetRect = CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight)

        // Starten des Grafikkontexts für die Zeichnung
        UIGraphicsBeginImageContextWithOptions(targetRect.size, false, 1.0)
        
        // Zeichnen des ursprünglichen Bildes in das Zielrechteck
        image.draw(in: targetRect)
        
        // Abrufen des skalierten Bildes aus dem aktuellen Grafikkontext
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // Beenden des Grafikkontexts
        UIGraphicsEndImageContext()

        // Rückgabe des skalierten Bildes (oder des ursprünglichen Bildes, falls das Skalieren fehlschlägt)
        return newImage ?? image
    }
}
