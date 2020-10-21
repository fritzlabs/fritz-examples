//
//  ImageSegmentationViewController
//  FritzAIStudio
//
//  Created by Chris Kelly on 9/12/2018.
//  Copyright © 2018 Fritz Labs, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import Fritz
import VideoToolbox



class ImageSegmentationViewController: FeatureViewController {

  static let defaultOptions: ConfigurableOptions = [
    .minThreshold: RangeValue(optionType: .minThreshold, min: 0.0, max: 1.0, value: 0.5, priority: 0),
    .alpha: RangeValue(optionType: .alpha, min: 0.0, max: 255.0, value: 190.0, priority: 1)
  ]

  override var debugImage: UIImage? { return UIImage(named: "eric.jpg") }

  convenience init() {
    let peopleSeg = FritzModelDetails(
      with: FritzVisionPeopleSegmentationModelFast().managedModel,
      featureDescription: .peopleSegmentation
    )

    let modelGroup = ModelGroupManager(
      initialModel: peopleSeg,
      tagName: "aistudio-ios-image-segmentation"
    )

    self.init(modelGroup: modelGroup, title: "Image Segmentation")
    streamBackgroundImage = true
  }

  /// Image Segmentation feature. Segments images into different classes.  For more information, see https://docs.fritz.ai/develop/vision/image-segmentation/about.html.
  override func build(_ predictorDetails: FritzModelDetails) -> AIStudioImagePredictor? {
    guard let model = predictorDetails.managedModel.loadModel()
      else { return nil }

    let modelType = predictorDetails.featureDescription
    var segmentationPredictor: FritzVisionSegmentationPredictor? = nil
    
    switch modelType {
    case .peopleSegmentation:
      segmentationPredictor = FritzVisionPeopleSegmentationPredictor(model: model)
    case .livingRoomSegmentation:
      segmentationPredictor = FritzVisionLivingRoomSegmentationPredictor(model: model)
    case .outdoorSegmentation:
      segmentationPredictor = FritzVisionOutdoorSegmentationPredictor(model: model)
    case .petSegmentation:
      segmentationPredictor = FritzVisionPetSegmentationPredictor(model: model)
    case .skySegmentation:
      segmentationPredictor = FritzVisionSkySegmentationPredictor(model: model)
    default:
      return nil
    }
    if let segmentationPredictor = segmentationPredictor {
      return AIStudioImagePredictor(model: segmentationPredictor, predictorDetails: predictorDetails)
    }
    return nil
  }
}


