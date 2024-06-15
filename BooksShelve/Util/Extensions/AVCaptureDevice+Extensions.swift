//
//  AVCaptureDevice+Extensions.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 17/04/24.
//

import AVFoundation

extension AVCaptureDevice {
    
    /// Returns best built in back camera for scanning QR codes zoomed for a given minimum code size.
    static func zoomedCameraForQRCode(withMinimumCodeSize minimumCodeSize: Float = 20) -> AVCaptureDevice? {
        let captureDevice = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .back
        ).devices.first ?? AVCaptureDevice.default(for: .video)
        captureDevice?.setRecommendedZoomFactor(forMinimumCodeSize: minimumCodeSize)
        return captureDevice
    }
    
    /// Sets recommended zoom factor for a given minimum code size.
    @available(iOS 15.0, *)
    func setRecommendedZoomFactor(forMinimumCodeSize minimumCodeSize: Float) {
        /*
         Optimize the user experience for scanning QR codes down to given size.
         When scanning a QR code of that size, the user may need to get closer than
         the camera's minimum focus distance to fill the rect of interest.
         To have the QR code both fill the rect and still be in focus, we may need to apply some zoom.
         */
        let deviceMinimumFocusDistance = Float(minimumFocusDistance)
        guard deviceMinimumFocusDistance != -1 else { return }
        
        let deviceFieldOfView = activeFormat.videoFieldOfView
        let formatDimensions = CMVideoFormatDescriptionGetDimensions(activeFormat.formatDescription)
        let rectOfInterestWidth = Double(formatDimensions.height) / Double(formatDimensions.width)
        let minimumSubjectDistanceForCode = minimumSubjectDistanceForCode(
            fieldOfView: deviceFieldOfView,
            minimumCodeSize: minimumCodeSize,
            previewFillPercentage: Float(rectOfInterestWidth)
        )
        
        guard minimumSubjectDistanceForCode < deviceMinimumFocusDistance else { return }
        
        let zoomFactor = deviceMinimumFocusDistance / minimumSubjectDistanceForCode
        do {
            try lockForConfiguration()
            videoZoomFactor = CGFloat(zoomFactor)
            unlockForConfiguration()
        } catch {
            print("Could not lock for configuration: \(error)")
        }
    }
    
    private func minimumSubjectDistanceForCode(
        fieldOfView: Float,
        minimumCodeSize: Float,
        previewFillPercentage: Float
    ) -> Float {
        /*
         Given the camera horizontal field of view, we can compute the distance (mm) to make a code
         of minimumCodeSize (mm) fill the previewFillPercentage.
         */
        let radians = (fieldOfView / 2).radians
        let filledCodeSize = minimumCodeSize / previewFillPercentage
        return filledCodeSize / tan(radians)
    }
}

private extension Float {
    var radians: Float {
        self * Float.pi / 180
    }
}
