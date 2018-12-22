//
//  CameraController.swift
//  Instgram
//
//  Created by ASUGARDS on 12/16/18.
//  Copyright © 2018 Mahmoud Mohammed. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UINavigationController {

  let dismissButton: UIButton = {
    let btn = UIButton(type: .system)
    btn.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
    btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return btn
  }()

  let capturePhotoButton: UIButton = {
    let btn = UIButton(type: .system)
    btn.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
    btn.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
    return btn
  }()

  @objc func handleDismiss() {
    dismiss(animated: true, completion: nil)
  }

  @objc func handleCapturePhoto() {
    print("Capturing...")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupHUD()
    setupCaptureSession()
  }

  fileprivate func setupHUD() {
    view.addSubview(capturePhotoButton)
    capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
    capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    view.addSubview(dismissButton)
    dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
  }
  
  fileprivate func setupCaptureSession() {
    let captureSession = AVCaptureSession()

    // 1. setup Inputs
    guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)
      if captureSession.canAddInput(input) {
        captureSession.addInput(input)
      }
    } catch let err {
      print(err.localizedDescription)
    }

    // 2. setup outputs
    let output = AVCapturePhotoOutput()
    if captureSession.canAddOutput(output) {
      captureSession.addOutput(output)
    }

    //3. setup output preview
    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.frame
    view.layer.addSublayer(previewLayer)

    captureSession.startRunning()
  }

}
