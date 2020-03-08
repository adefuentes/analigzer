//
//  IGSelfHeaderView.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 20/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit

class IGAccountHeaderView: UIView {
    
    public var imageUser: UIImageView!
    public var followersLabel: UIButton!
    public var followedLabel: UIButton!
    public var bigImageUser: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension IGAccountHeaderView {
    
    func setupViews() {
        
        let borderView = IGGradientBorderView()
        
        borderView.square(edge: 95)
        
        borderView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        borderView.createBorder(4)
        borderView.createRoundCorner(47.5)

        
        bigImageUser = {
            
            let imageView = UIImageView()
            
            imageView.clipsToBounds = true
            
            return imageView
            
        }()
        
        imageUser = {
           
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 40
            imageView.clipsToBounds = true
            
            return imageView
            
        }()
        
        followedLabel = {
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 2
            return button
        }()
        
        followersLabel = {
            let button = UIButton()
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 2
            return button
        }()
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        bigImageUser.translatesAutoresizingMaskIntoConstraints = false
        imageUser.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        followedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bigImageUser)
        addSubview(borderView)
        addSubview(imageUser)
        addSubview(followersLabel)
        addSubview(followedLabel)
        
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: bigImageUser)
        addConstraintsWithFormat(visualFormat: "V:|[v0]|", views: bigImageUser)
        addConstraintsWithFormat(visualFormat: "H:|-[v0]-[v1(80)]-[v2]-|", views: followersLabel, imageUser, followedLabel)
        addConstraintsWithFormat(visualFormat: "V:[v0(80)]", views: imageUser)
        centerWithConstraints(borderView)
        centerWithConstraints(imageUser)
        centerVerticalWithConstraints(followersLabel)
        centerVerticalWithConstraints(imageUser)
        centerVerticalWithConstraints(followedLabel)
        
    }
    
}

class IGGradientBorderView: UIView {
    //138, 58, 185
    //251, 173, 80
    var colors: [UIColor] = [UIColor(red: 138/255, green: 58/255, blue: 185/255, alpha: 1),
                             UIColor(red: 251/255, green: 173/255, blue: 80/255, alpha: 1)]
    var startPoint = CGPoint.zero
    var endPoint = CGPoint(x: 1, y: 1)
    private var cornerRadius: CGFloat = 0
    private var borderWidth: CGFloat = 0
    private var gradientLayer = CAGradientLayer()
    private var backgroundView = UIView()
    
    override var backgroundColor: UIColor? {
        didSet {
            backgroundView.backgroundColor = backgroundColor
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        setupView()
    }
    
    convenience init(colors: [UIColor] = [], startPoint: CGPoint = .zero, endPoint: CGPoint = CGPoint(x: 0, y: 0)) {
        self.init(frame: .zero)
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        backgroundColor = .white
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    internal func setupView() {
        
        gradientLayer.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map({ return $0.cgColor })
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
        
        backgroundView.removeFromSuperview()
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(backgroundView, at: 1)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.fill(toView: self, space: UIEdgeInsets(space: borderWidth))
        
        createRoundCorner(cornerRadius)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    override func createRoundCorner(_ radius: CGFloat) {
        cornerRadius = radius
        super.createRoundCorner(radius)
        backgroundView.createRoundCorner(radius - borderWidth)
    }
    
    func createBorder(_ width: CGFloat) {
        borderWidth = width
        setupView()
    }
}

extension UIView {
    @objc func createRoundCorner(_ radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}


extension UIView {
    
    func addConstraint(attribute: NSLayoutConstraint.Attribute, equalTo view: UIView, toAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        
        let myConstraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: toAttribute, multiplier: multiplier, constant: constant)
        return myConstraint
    }
    
    func addConstraints(withFormat format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for i in 0 ..< views.count {
            let key = "v\(i)"
            views[i].translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = views[i]
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    @discardableResult
    public func left(toAnchor anchor: NSLayoutXAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = leftAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func left(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = leftAnchor.constraint(equalTo: view.leftAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func right(toAnchor anchor: NSLayoutXAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = rightAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func right(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = rightAnchor.constraint(equalTo: view.rightAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func top(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func top(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.topAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func topLeft(toView view: UIView, top: CGFloat = 0, left: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let topConstraint = self.top(toView: view, space: top)
        let leftConstraint = self.left(toView: view, space: left)
        
        return [topConstraint, leftConstraint]
    }
    
    @discardableResult
    public func topRight(toView view: UIView, top: CGFloat = 0, right: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let topConstraint = self.top(toView: view, space: top)
        let rightConstraint = self.right(toView: view, space: right)
        
        return [topConstraint, rightConstraint]
    }
    
    @discardableResult
    public func bottomRight(toView view: UIView, bottom: CGFloat = 0, right: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let bottomConstraint = self.bottom(toView: view, space: bottom)
        let rightConstraint = self.right(toView: view, space: right)
        
        return [bottomConstraint, rightConstraint]
    }
    
    @discardableResult
    public func bottomLeft(toView view: UIView, bottom: CGFloat = 0, left: CGFloat = 0) -> [NSLayoutConstraint] {
        
        let bottomConstraint = self.bottom(toView: view, space: bottom)
        let leftConstraint = self.left(toView: view, space: left)
        
        return [bottomConstraint, leftConstraint]
    }
    
    @discardableResult
    public func bottom(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func bottom(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func verticalSpacing(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        
        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func horizontalSpacing(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        
        let constraint = rightAnchor.constraint(equalTo: view.leftAnchor, constant: -space)
        constraint.isActive = true
        return constraint
    }
    
    
    public func size(_ size: CGSize) {
        
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
    }
    
    public func size(toView view: UIView, greater: CGFloat = 0) {
        widthAnchor.constraint(equalTo: view.widthAnchor, constant: greater).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, constant: greater).isActive = true
    }
    
    public func square(edge: CGFloat) {
        
        size(CGSize(width: edge, height: edge))
    }
    
    public func square() {
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1, constant: 0).isActive = true
    }
    
    @discardableResult
    public func width(_ width: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func width(toDimension dimension: NSLayoutDimension, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    
    @discardableResult
    public func width(toView view: UIView, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func height(_ height: CGFloat) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func height(toDimension dimension: NSLayoutDimension, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalTo: dimension, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func height(toView view: UIView, multiplier: CGFloat = 1, greater: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: greater)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func centerX(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func centerX(toAnchor anchor: NSLayoutXAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerXAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    public func center(toView view: UIView, space: CGFloat = 0){
        centerX(toView: view, space: space)
        centerY(toView: view, space: space)
    }
    
    @discardableResult
    public func centerY(toView view: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    public func centerY(toAnchor anchor: NSLayoutYAxisAnchor, space: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = centerYAnchor.constraint(equalTo: anchor, constant: space)
        constraint.isActive = true
        return constraint
    }
    
    
    public func horizontal(toView view: UIView, space: CGFloat = 0) {
        
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: space).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: -space).isActive = true
    }
    
    public func horizontal(toView view: UIView, leftPadding: CGFloat, rightPadding: CGFloat) {
        
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftPadding).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: rightPadding).isActive = true
    }
    
    public func vertical(toView view: UIView, space: CGFloat = 0) {
        
        topAnchor.constraint(equalTo: view.topAnchor, constant: space).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -space).isActive = true
    }
    
    public func vertical(toView view: UIView, topPadding: CGFloat, bottomPadding: CGFloat) {
        
        topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomPadding).isActive = true
    }
    
    
    public func fill(toView view: UIView, space: UIEdgeInsets = .zero) {
        
        left(toView: view, space: space.left)
        right(toView: view, space: -space.right)
        top(toView: view, space: space.top)
        bottom(toView: view, space: -space.bottom)
    }
    
    
    
}

extension UIEdgeInsets {
    
    init(space: CGFloat) {
        self.init(top: space, left: space, bottom: space, right: space)
    }
    
    
}
