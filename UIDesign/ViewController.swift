//
//  ViewController.swift
//  UIDesign
//
//  Created by Htet Myat Tun on 30/05/2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var cvSlider: UICollectionView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var roomView: UIView!
    
    @IBOutlet weak var btnByRoom: LeftButton!
    @IBOutlet weak var btnByRate: UIButton!
    @IBOutlet weak var uvBackground: UIView!
    @IBOutlet weak var img: UIImageView!
    
    private let imageNames = ["bridge", "shanghai", "hongkong"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cvSlider.delegate = self
        cvSlider.dataSource = self
        
        cvSlider.register(UINib.init(nibName: "PhotoCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCell")
        
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        cvSlider.collectionViewLayout = layout
        
        let width = (view.frame.width - 90)
        layout = cvSlider.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: 200)
        
        borderView.addDashedBorder()
        
        img.image = UIImage(named: "bridge")
        borderView.isHidden = false
        roomView.isHidden = true
        
        startSlideshow()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.assignImage(img: imageNames[indexPath.row])
        return cell
    }
    
    // MARK: - Slideshow
    
    private var timer: Timer?
    private var currentIndex = 0
    
    private func startSlideshow() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextImage), userInfo: nil, repeats: true)
    }
    
    @objc private func scrollToNextImage() {
        currentIndex += 1
        if currentIndex >= imageNames.count {
            currentIndex = 0
        }
        let indexPath = IndexPath(row: currentIndex, section: 0)
        cvSlider.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func btnToggle(_ sender: UIButton) {
        let bgColor = UIColor(red: 151/255.0, green: 192/255.0, blue: 212/255.0, alpha: 1)
        if sender == btnByRoom {
            btnByRoom.setNeedsDisplay()
            uvBackground.backgroundColor = UIColor.white
            uvBackground.layer.borderWidth = 1
            uvBackground.layer.borderColor = bgColor.cgColor
            btnByRoom.isEnabled = false
            btnByRate.isEnabled = true
            borderView.isHidden = true
            roomView.isHidden = false
        } else {
            uvBackground.backgroundColor = bgColor
            btnByRoom.isEnabled = true
            btnByRate.isEnabled = false
            borderView.isHidden = false
            roomView.isHidden = true
        }
        
        LeftButton.isBtnByRoomActive = !LeftButton.isBtnByRoomActive
    }
}

class LeftButton: UIButton {
    static var isBtnByRoomActive = false
    
    override func draw(_ rect: CGRect) {
        let bgColor = UIColor(red: 151/255.0, green: 192/255.0, blue: 212/255.0, alpha: 1)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX + 20, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - 20, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.close()
        
        if LeftButton.isBtnByRoomActive {
            bgColor.setFill()
            path.fill()
        } else {
            UIColor.white.setFill()
            path.fill()
        }
        
        bgColor.setStroke()
        path.lineWidth = 1.0
        path.stroke()
        
        super.draw(rect)
    }
}

class RightButton: UIButton {
    override func draw(_ rect: CGRect) {
        let bgColor = UIColor(red: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 0.8)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX + 20, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.close()
        
        bgColor.setFill()
        path.fill()
        
        super.draw(rect)
    }
}

extension UIView {
    func addDashedBorder() {
        let color = UIColor(red: 151/255.0, green: 192/255.0, blue: 212/255.0, alpha: 1).cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [1,4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
