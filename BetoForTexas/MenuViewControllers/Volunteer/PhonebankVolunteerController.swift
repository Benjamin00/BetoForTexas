//
//  PhonebankVolunteerController.swift
//  BetoForTexas
//
//  Created by Benjamin on 8/22/18.
//  Copyright © 2018 BenjaminHill. All rights reserved.
//

import Foundation
import UIKit

class PhonebankViewController: UIViewController, UIScrollViewDelegate{

      var vslides:[VolunteerSlides] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Phonebank"
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        vslides = createSlides()
        setupSlideScrollView(slides: vslides)
        
        print("number of pages" , vslides.count)
        pageControl.numberOfPages = vslides.count
        pageControl.currentPage = 0
        self.view.addSubview(pageControl)
        view.bringSubview(toFront: pageControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createSlides() -> [VolunteerSlides] {
        // let imageA1: UIImage? = nil
        var retArr = [VolunteerSlides]()
        let slide1:VolunteerSlides = Bundle.main.loadNibNamed("VSlide", owner: self, options: nil)?.first as! VolunteerSlides
        
        //Slide1
        slide1.volText.text = "Before you get started, it's important to get training. The volunteers you will be speaking to will guide you through the process, and give you the links you need. It's important that you have access to a computer for your training as you will be using a webpage to make the phone calls."
        slide1.volTitle.text = "Get Trained"
        slide1.volButton.whenButtonIsClicked{
            let polisurl:URL = URL(string:"https://docs.google.com/document/d/1e9vjvw9FXWpmbC1-TjXR-chUXcfOxGyeTOaYKUyRQdk/edit")!
            UIApplication.shared.open(polisurl as URL, options: [:])
        }
        slide1.volButton.setTitle("Register", for: UIControlState.normal)
        retArr.append(slide1)
        
        return retArr
        
    }
    func setupSlideScrollView(slides : [VolunteerSlides]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        //        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        //        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
