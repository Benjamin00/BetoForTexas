//
//  CanvassViewController.swift
//  BetoForTexas
//
//  Created by Benjamin on 6/29/18.
//  Copyright © 2018 BenjaminHill. All rights reserved.
//

import UIKit

class CanvassViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var vslides:[VolunteerSlides] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Canvass"
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
        slide1.volText.text = "In order to get you signed up to knock on doors for Beto, we need you to register with the 'Pollis' app, which we use to coordinate where you will be going with our other team members. Tap the button below to sign up."
        slide1.volTitle.text = "First Steps"
        slide1.volButton.whenButtonIsClicked{
            let polisurl:URL = URL(string:"https://knock.polisapp.com/join/o4Te8iqfkj")!
            UIApplication.shared.open(polisurl as URL, options: [:])
        }
        slide1.volButton.setTitle("Register", for: UIControlState.normal)
        retArr.append(slide1)
       
        //Slide2
        let slide2:VolunteerSlides = Bundle.main.loadNibNamed("VSlide", owner: self, options: nil)?.first as! VolunteerSlides
        slide2.volText.text = "Now, you're going to need to download the app on your phone. Once you've downloaded it, go ahead and sign in with the account you just created"
        slide2.volTitle.text = "Download the App"
        slide2.volButton.whenButtonIsClicked{
            let polisurl:URL = URL(string:"https://itunes.apple.com/us/app/polis-canvassing-app/id1056995960?ls=1&mt=8")!
            UIApplication.shared.open(polisurl as URL, options: [:])
        }
        slide2.volButton.setTitle("Download", for: UIControlState.normal)
        retArr.append(slide2)
        
        //Slide 3
        let slide3:VolunteerSlides = Bundle.main.loadNibNamed("VSlide", owner: self, options: nil)?.first as! VolunteerSlides
        slide3.volText.text = "Great! Now that you're all set up, you're going to need some training. This training will be with another Beto campaign volunteer, and shouldn't take more than 40 or 50 minutes. Follow the link below to sign up for a training slot"
        slide3.volTitle.text = "Get Trained!"
        slide3.volButton.whenButtonIsClicked{
            let polisurl:URL = URL(string:"https://docs.google.com/document/d/1e9vjvw9FXWpmbC1-TjXR-chUXcfOxGyeTOaYKUyRQdk/edit")!
            UIApplication.shared.open(polisurl as URL, options: [:])
        }
        slide3.volButton.setTitle("Sign Up", for: UIControlState.normal)
        retArr.append(slide3)
        //Slide 3
        let slide4:VolunteerSlides = Bundle.main.loadNibNamed("VSlide", owner: self, options: nil)?.first as! VolunteerSlides
        slide4.volText.text = "Thank you so much for your interest in volunteering. It's with the help from people like you that we'll get people out to vote, and win in November."
        slide4.volTitle.text = "That's it!"
        slide4.volButton.isHidden = true
        retArr.append(slide4)
        return retArr;
        
        
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
