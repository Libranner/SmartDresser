//
//  ScannerViewController.swift
//  DressAsistant
//
//  Created by Libranner Leonel Santos Espinal on 25/08/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

import AVFoundation
import UIKit

protocol ScannerViewControllerDelegate  {
  func scannedCode(_ code: String)
  func dismissScan()
}

class ScannerViewController: UIViewController {
  private var captureSession: AVCaptureSession!
  private var previewLayer: AVCaptureVideoPreviewLayer!
  var delegate: ScannerViewControllerDelegate?
  
  enum Localizations {
    static let closeModal = "close-modal"
    static let scanQRTitle = "scan-QR-title"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let closeButton = UIBarButtonItem(title: NSLocalizedString(Localizations.closeModal, comment: ""),
                                      style: .plain,
                                      target: self,
                                      action: #selector(dismissAction))
    
    navigationItem.leftBarButtonItem = closeButton
    title = NSLocalizedString(Localizations.scanQRTitle, comment: "")
    
    view.backgroundColor = UIColor.black
    configureSession()
  }
  
  @objc func dismissAction(_ sender: Any) {
    self.dismiss(animated: true)
    delegate?.dismissScan()
  }
  
  private func configureSession() {
    captureSession = AVCaptureSession()
    
    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
    let videoInput: AVCaptureDeviceInput
    
    do {
      videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
    } catch {
      return
    }
    
    if (captureSession.canAddInput(videoInput)) {
      captureSession.addInput(videoInput)
    } else {
      failed()
      return
    }
    
    let metadataOutput = AVCaptureMetadataOutput()
    
    if (captureSession.canAddOutput(metadataOutput)) {
      captureSession.addOutput(metadataOutput)
      
      metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      metadataOutput.metadataObjectTypes = [.qr]
    } else {
      failed()
      return
    }
    
    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.layer.bounds
    previewLayer.videoGravity = .resizeAspectFill
    view.layer.addSublayer(previewLayer)
    
    captureSession.startRunning()
  }
  
  private func failed() {
    let ac = UIAlertController(title: "Escaneo no disponible", message: "Su dispositivo no soporta esta funcionalidad.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default))
    present(ac, animated: true)
    captureSession = nil
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if (captureSession?.isRunning == false) {
      captureSession.startRunning()
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if (captureSession?.isRunning == true) {
      captureSession.stopRunning()
    }
  }
}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    captureSession.stopRunning()
    
    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
      guard let stringValue = readableObject.stringValue else { return }
      AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
      found(code: stringValue)
    }
    
    dismiss(animated: true)
  }
  
  func found(code: String) {
    delegate?.scannedCode(code)
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
}
