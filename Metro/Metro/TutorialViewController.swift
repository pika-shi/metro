//
//  TutorialViewController.swift
//  Metro
//
//  Created by yokota on 2014/10/24.
//  Copyright (c) 2014年 job2. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIViewController,UIScrollViewDelegate{
    
    let page_padding:CGFloat = 30
    var scroll_begin_point:CGPoint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var finishBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var pages = 2
        var width = self.view.frame.width
        var height = scrollView.frame.height
        self.view.backgroundColor = UIColorFromRGB(0x0ea4a0)
        let scroll_width = CGFloat(pages)*width
        scrollView.frame = CGRectMake(0, 0, width, height)
        scrollView.bounds = CGRectMake(0, 0, 50, height)

        scrollView.contentSize = CGSizeMake(scroll_width, height)
        scrollView.pagingEnabled = true
        scrollView.scrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.userInteractionEnabled = true
        
        scrollView.delegate = self
        
        
        carouselViewSet(0, mes: "説明1", image: "carousel1.png")
        carouselViewSet(1, mes: "説明2", image: "carousel2.png")

        
        finishBtn.backgroundColor = UIColorFromRGB(0x0ea4a0)
        finishBtn.addTarget(self, action: "endTutorial", forControlEvents: .TouchUpInside)

        
        
    }
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func buttonSet(page:CGFloat,title:String,x:CGFloat,y:CGFloat,type:BButtonType)->UIButton{
        var btn = BButton(frame: CGRectMake(scrollView.frame.width*page+x, y, 172, 44))
        btn.setTitle(title, forState: .Normal)
        btn.setStyle(BButtonStyle.BootstrapV2)
        btn.setType(type)
        
        scrollView.addSubview(btn)
        return btn
    }
    
    func carouselViewSet(page:CGFloat,mes:String, image:String){
        var labelposx:CGFloat = (320-0*page_padding)*page;
        let backx = labelposx
        let backwidth = self.view.frame.width
        var backView:UIView = UIView(frame: CGRectMake(backx, 0, backwidth, scrollView.frame.height))
        backView.backgroundColor = UIColorFromRGB(0x0ea4a0)
        let centerx = labelposx+page_padding
        let centerwidth:CGFloat = 320-page_padding*2
        var centerImage = UIImage(named: image)
        var centerView:UIImageView = UIImageView(frame: CGRectMake(centerx, 50, centerwidth, 469))
        centerView.image = centerImage
        var label:UILabel = UILabel(frame: CGRectMake(centerx,scrollView.frame.height/7, centerwidth, 100))
        label.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 1, alpha: 0.8)
        label.text = mes
        scrollView.addSubview(backView)
        scrollView.addSubview(centerView)
        scrollView.addSubview(label)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
                var pageWidth : CGFloat = self.scrollView.frame.size.width
        var fractionalPage : Double = Double(self.scrollView.contentOffset.x / pageWidth)
        var page : NSInteger = lround(fractionalPage)
        self.pageControl.currentPage = page;
        
    }
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        scroll_begin_point = scrollView.contentOffset
//    }
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if (scroll_begin_point.x > scrollView.contentOffset.x){
//            self.pageControl.currentPage += 1
//            self.scrollView.setContentOffset(CGPointMake(320,0), animated: true)
//        }else{
//            self.pageControl.currentPage -= 1
//            self.scrollView.setContentOffset(CGPointMake(320,0), animated: true)
//        }
//
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func endTutorial(){
        
        
        var userDef = NSUserDefaults.standardUserDefaults()
        userDef.setBool(true,forKey:"tutorial")
        self.dismissViewControllerAnimated(true, completion: nil)
        
    
        
    }
}