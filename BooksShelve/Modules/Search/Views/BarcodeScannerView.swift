//
//  BarCodeScanner.swift
//  BooksShelve
//
//  Created by Marcos Debastiani on 16/04/24.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct BarcodeScannerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isPresentingScanner: Bool
    @Binding var scannedCode: String

    let codeTypes: [AVMetadataObject.ObjectType] = [
        .codabar,
        .code39,
        .code39Mod43,
        .code93,
        .code128,
        .ean8,
        .ean13,
        .gs1DataBar,
        .gs1DataBarExpanded,
        .gs1DataBarLimited,
        .interleaved2of5,
        .itf14,
        .upce
    ]
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 300, height: 200)
                .background(Color.black.opacity(0.5))
                .overlay {
                    ZStack {
                        CodeScannerView(codeTypes: codeTypes, videoCaptureDevice: AVCaptureDevice.zoomedCameraForQRCode(withMinimumCodeSize: 20)) { response in
                            if case let .success(result) = response {
                                scannedCode = result.string
                            }
                        }
                        Text(scannedCode)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                }
                .cornerRadius(20)
        }
        .onChange(of: isPresentingScanner) {
            dismiss()           
        }
    }
    
    func getDevice() {
        let captureDevice = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .back
        ).devices.first ?? AVCaptureDevice.default(for: .video)
        captureDevice?.setRecommendedZoomFactor(forMinimumCodeSize: 20)
    }
}

#Preview {
    BarcodeScannerView(isPresentingScanner: .constant(true), scannedCode: .constant(""))
}
