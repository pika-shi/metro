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
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var pages = 3
        var width = scrollView.frame.width
        var height = scrollView.frame.height
        self.view.backgroundColor = UIColorFromRGB(0xA9D8D2)
        scrollView.contentSize = CGSizeMake(CGFloat(pages)*width, height)
        scrollView.pagingEnabled = true
        scrollView.scrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.userInteractionEnabled = true
        scrollView.delegate = self
        
        
        carouselViewSet(0, mes: "説明1")
        carouselViewSet(1, mes: "説明2")
        carouselViewSet(2, mes: "説明3")
//        var endButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
//        endButton.frame = CGRectMake(width*2+180, 600, 172, 44)
//        endButton.setTitle("初期登録へ", forState: .Normal)
//        endButton.setTitle("初期登録へ", forState: .Highlighted)
//        endButton.setTitleColor(UIColor.whiteColor(), forState:.Normal)
//        endButton.setTitleColor(UIColor.whiteColor(), forState:.Highlighted)
//        endButton.backgroundColor = UIColorFromRGB(0xED8472)
//        endButton.layer.cornerRadius = 5
//        endButton.addTarget(self, action: "endTutorial:", forControlEvents: .TouchUpInside)
//        scrollView.addSubview(endButton)
        buttonSet(0, title: "次へ", x: 180, y: 600,type:BButtonType.Success)
        buttonSet(1, title: "前へ", x: 10, y: 600,type:BButtonType.Warning)
        buttonSet(1, title: "次へ", x: 190, y: 600,type:BButtonType.Primary)
        buttonSet(2, title: "前へ", x: 10, y: 600,type:BButtonType.Info)
        buttonSet(2, title: "初期登録へ", x: 190, y: 600,type:BButtonType.Default)
        

        
        
    }
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    func buttonSet(page:CGFloat,title:String,x:CGFloat,y:CGFloat,type:BButtonType){
        var btn = BButton(frame: CGRectMake(scrollView.frame.width*page+x, y, 172, 44))
        btn.setTitle(title, forState: .Normal)
        btn.setStyle(BButtonStyle.BootstrapV2)
        btn.setType(type)
        
        scrollView.addSubview(btn)
    }
    
    func carouselViewSet(page:CGFloat,mes:String ){
        var labelposx:CGFloat = scrollView.frame.width*page;
        var backView:UIView = UIView(frame: CGRectMake(labelposx, 0, scrollView.frame.width, scrollView.frame.height))
        backView.backgroundColor = UIColorFromRGB(0xA9D8D2)
        var centerView:UIView = UIView(frame: CGRectMake(labelposx+scrollView.frame.width/5, scrollView.frame.height/7, scrollView.frame.width*3/5, scrollView.frame.height*4/7))
        centerView.backgroundColor = UIColorFromRGB(0xEDF7F5)
        var label:UILabel = UILabel(frame: CGRectMake(labelposx, 430, scrollView.frame.width, 237))
        label.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 1, alpha: 0.8)
        label.text = mes
        scrollView.addSubview(backView)
        scrollView.addSubview(centerView)
        scrollView.addSubview(label)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        NSLog("scrolled!");
        var pageWidth : CGFloat = self.scrollView.frame.size.width
        var fractionalPage : Double = Double(self.scrollView.contentOffset.x / pageWidth)
        var page : NSInteger = lround(fractionalPage)
        self.pageControl.currentPage = page;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func endTutorial(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}