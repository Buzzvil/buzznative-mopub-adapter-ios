//
//  BAROAdAdapter.swift
//  MopubAdapterSample
//
//  Created by Jaehee Ko on 27/08/2018.
//  Copyright © 2018 Buzzvil. All rights reserved.
//

import Foundation
import BARO
import MoPub // Delete this line if you integrate MoPub with source codes

@objc(BAROAdAdapter)
class BAROAdAdapter: NSObject, MPNativeAdAdapter, MPAdImpressionTimerDelegate {
  var properties: [AnyHashable : Any]!
  var defaultActionURL: URL!
  var delegate: MPNativeAdAdapterDelegate!
  
  let impressionTimer: MPAdImpressionTimer
  
  var ad: BAROAd!

  init(ad: BAROAd) {
    self.ad = ad

    var properties: [AnyHashable: Any] = [:]
    properties[kAdTitleKey] = ad.creative.title
    properties[kAdTextKey] = ad.creative.body
    properties[kAdMainImageKey] = ad.creative.imageURL
    properties[kAdIconImageKey] = ad.creative.iconURL
    properties[kAdCTATextKey] = ad.creative.callToAction
    properties[kImpressionTrackerURLsKey] = ad.impressionTrackers
    properties[kClickTrackerURLKey] = ad.clickTrackers
    properties[kPrivacyIconTapDestinationURL] = ad.creative.adchoiceURL
    self.properties = properties

    if let url = ad.creative.clickURL {
      self.defaultActionURL = URL(string: url)
    }
    
    self.impressionTimer = MPAdImpressionTimer(requiredSecondsForImpression: 0.5, requiredViewVisibilityPercentage: 0.5)

    super.init()
    
    impressionTimer.delegate = self
  }
  
  func willAttach(to view: UIView!) {
    willAttach(to: view, withAdContentViews: [])
  }
  
  func willAttach(to view: UIView!, withAdContentViews adContentViews: [Any]!) {
    impressionTimer.startTrackingView(view)
  }
  
  func adViewWillLogImpression(_ adView: UIView!) {
    BAROAdTracker.adImpressed(ad)
    delegate.nativeAdWillLogImpression?(self)
  }

  func trackClick() {
    BAROAdTracker.adClicked(ad)
  }
  
  func displayContent(for URL: URL!, rootViewController controller: UIViewController!) {
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(URL, options: [:], completionHandler: nil)
    } else {
      UIApplication.shared.openURL(URL)
    }
  }
}
