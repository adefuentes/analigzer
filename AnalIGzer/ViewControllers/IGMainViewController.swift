//
//  IGMainViewController.swift
//  AnalIGzer
//
//  Created by Angel Fuentes on 17/11/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import UIKit
import SwiftInstagram
import ScrollableGraphView
import DGElasticPullToRefresh
import CoreData

public let kPALETTE_COLORS: [UIColor] = [UIColor(red: 138/255, green: 58/255, blue: 185/255, alpha: 1),
                                         UIColor(red: 76/255, green: 104/255, blue: 215/255, alpha: 1),
                                         UIColor(red: 205/255, green: 72/255, blue: 107/255, alpha: 1),
                                         UIColor(red: 251/255, green: 173/255, blue: 80/255, alpha: 1),
                                         UIColor(red: 188/255, green: 42/255, blue: 141/255, alpha: 1),
                                         UIColor(red: 233/255, green: 89/255, blue: 80/255, alpha: 1)]

class IGMainViewController: UITableViewController {

    private let api = IGGetUser()
    private var rows: Int = 0
    private var userData: IGUserModel! {
        didSet {
            
            rows = graphTitles.count + 2
            tableView.reloadData()
            
        }
    }
    private var graphTitles: [String] = ["Seguidores este último mes",
                                         "Seguidos este último mes",
                                         "Número de comentarios este último mes",
                                         "Número de likes este último mes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        
        
        api.delegate = self
        api.getPrimalData(userID: IGSavedData.userID ?? "")
        
        setupViews()
        
        
    }
    
    func getSavedOwner() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Owner")
        
        do {
            let owners = try managedContext.fetch(fetchRequest)
            
            for owner in owners {
                if let id = owner.value(forKey: "id") as? String {
                    if id == IGSavedData.userID {
                        print(owner)
                    }
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    deinit {
        tableView.dg_removePullToRefresh()
    }

}

extension IGMainViewController: IGGetUserDelegate {
    
    func getUser(withSuccess success: IGUserModel) {
        print(success.graphql?.user?.full_name ?? "No data")
        navigationItem.title = "@\(success.graphql?.user?.username ?? "")"
        userData = success
        tableView.dg_stopLoading()
    }
    
    func getUser(withPrimal primalData: IGPrimalModel) {
        api.getUser(user: primalData.data?.user?.reel?.user?.username ?? "")
    }
    
    func getUser(withError error: String) {
        
        let alert = UIAlertController(title: "Oh oh!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension IGMainViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > 1 {
            return 200
        } else {
            return 150
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? IGHeaderViewCell else {
                return UITableViewCell()
            }
            
            cell.delegate = self
            cell.data = userData
            
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "functionsCell") as? IGFunctionsViewCell else {
                return UITableViewCell()
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "chartCell") as? IGChartViewCell else {
                return UITableViewCell()
            }
            
            cell.titleGraphlabel.text = graphTitles[indexPath.row - 2]
            cell.color = kPALETTE_COLORS[indexPath.row - 2]
            cell.points = [Int.random(in: 1..<50),
                           Int.random(in: 1..<50),
                           Int.random(in: 1..<50),
                           Int.random(in: 1..<50),
                           Int.random(in: 1..<50),
                           Int.random(in: 1..<50),
                           Int.random(in: 1..<50),
                           Int.random(in: 1..<50),
                           Int.random(in: 1..<50),
                           Int.random(in: 1..<50)]
            
            return cell
        }
        
    }
    
}

extension IGMainViewController: IGHeaderViewCellDelegate {
    
    func headerView(followersSelected sender: UIButton) {
        
        let followersController = IGFollowers()
        
        followersController.delegate = self
        followersController.getFollowedBy(.followers)
        
    }
    
    func headerView(followedSelected sender: UIButton) {
        let followersController = IGFollowers()
        
        followersController.delegate = self
        followersController.getFollowedBy(.followed)
        
    }
    
}

extension IGMainViewController: IGFollowersDelegate {
    
    func followers(_ success: IGFollowedModel) {
        
        let viewController = IGRelationshipViewController()
        viewController.edges = success.data?.user?.edge_follow
        viewController.type = .followed
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func followers(_ success: IGFollowedByModel) {
        
        let viewController = IGRelationshipViewController()
        viewController.edges = success.data?.user?.edge_followed_by
        viewController.type = .followers
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func followers(_ error: String) {
        
        let alert = UIAlertController(title: "Oh Oh!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension IGMainViewController {
    
    func setupViews() {
        
        tableView.separatorStyle = .none
        tableView.register(IGHeaderViewCell.self, forCellReuseIdentifier: "headerCell")
        tableView.register(IGFunctionsViewCell.self, forCellReuseIdentifier: "functionsCell")
        tableView.register(IGChartViewCell.self, forCellReuseIdentifier: "chartCell")
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.black
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            self?.api.getPrimalData(userID: IGSavedData.userID ?? "")
            
        }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(.white)
        tableView.dg_setPullToRefreshBackgroundColor(UIColor(white: 0.97, alpha: 1))
        
    }
    
}

protocol IGHeaderViewCellDelegate: class {
    func headerView(followersSelected sender: UIButton)
    func headerView(followedSelected sender: UIButton)
}

class IGHeaderViewCell: UITableViewCell {
    
    var data: IGUserModel! {
        didSet {
            parse()
        }
    }
    
    public var delegate: IGHeaderViewCellDelegate?
    private let accountView = IGAccountHeaderView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.addSubview(accountView)
        accountView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        accountView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraintsWithFormat(visualFormat: "V:|[v0(150)]", views: accountView)
        self.addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: accountView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func parse() {
        let follwedBy = data.graphql?.user?.edge_followed_by?.count ?? 0
        
        self.accountView.imageUser.downloaded(from: data.graphql?.user?.profile_pic_url ?? "", contentMode: .scaleAspectFill)
        self.accountView.followersLabel.setTitle((follwedBy == 1) ? "\(follwedBy)\nseguidor" : "\(follwedBy)\nseguidores", for: .normal)
        self.accountView.followedLabel.setTitle("\(data.graphql?.user?.edge_follow?.count ?? 0)\nseguidos", for: .normal)
        self.accountView.followersLabel.addTarget(self, action: #selector(actionSelectedFollowers(_:)), for: .touchUpInside)
        self.accountView.followedLabel.addTarget(self, action: #selector(actionSelectedFollowed(_:)), for: .touchUpInside)
        
    }
    
    @objc func actionSelectedFollowers(_ sender: UIButton) {
        delegate?.headerView(followersSelected: sender)
    }
    
    @objc func actionSelectedFollowed(_ sender: UIButton) {
        delegate?.headerView(followedSelected: sender)
    }
    
}

class IGFunctionsViewCell: UITableViewCell {
    
    var collectionView: UICollectionView!
    let functions: [String] = ["Quien no me sigue ya",
                               "Usuarios que me han bloqueado",
                               "Comentarios y me gusta eliminados",
                               "Los que más comentan",
                               "Les sigo pero ellos a mi no",
                               "Os seguís mutuamente",
                               "Me gustas en total"]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView =  UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(IGFunctionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(visualFormat: "V:|[v0]|", views: collectionView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension IGFunctionsViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return functions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? IGFunctionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.functionLabel.text = functions[indexPath.row]
        cell.numerLabel.text = "12"
        cell.layer.cornerRadius = 10
        cell.backgroundColor = UIColor(white: 0.97, alpha: 1)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
}

class IGFunctionViewCell: UICollectionViewCell {
    
    public let functionLabel = UILabel()
    public let numerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        functionLabel.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        functionLabel.numberOfLines = 3
        functionLabel.textColor = .darkGray
        functionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        numerLabel.font = UIFont.systemFont(ofSize: 60, weight: .thin)
        numerLabel.textColor = .darkGray
        numerLabel.translatesAutoresizingMaskIntoConstraints = false
        numerLabel.adjustsFontSizeToFitWidth = true
        
        addSubview(numerLabel)
        addSubview(functionLabel)
        
        addConstraintsWithFormat(visualFormat: "H:|-[v0]-[v1]-|", views: numerLabel, functionLabel)
        addConstraintsWithFormat(visualFormat: "V:|-[v0]-|", views: numerLabel)
        addConstraintsWithFormat(visualFormat: "V:[v0(80)]-|", views: functionLabel)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class IGChartViewCell: UITableViewCell {
    
    let titleGraphlabel = UILabel()
    let linePlot = LinePlot(identifier: "darkLine")
    let dotPlot = DotPlot(identifier: "darkLineDot")
    let referenceLines = ReferenceLines()
    var graphView: ScrollableGraphView!
    
    let data: [String] = ["1 ENE 2018",
                          "2 ENE 2018",
                          "3 ENE 2018",
                          "4 ENE 2018",
                          "5 ENE 2018",
                          "6 ENE 2018",
                          "7 ENE 2018",
                          "8 ENE 2018",
                          "9 ENE 2018",
                          "10 ENE 2018"]
    
    var points: [Int] = [] {
        didSet {
            graphView.reload()
        }
    }
    
    public var color: UIColor! {
        didSet {
            linePlot.lineColor = color.withAlphaComponent(0.7)
            linePlot.fillGradientStartColor = color.withAlphaComponent(0.5)
            linePlot.fillGradientEndColor = color.withAlphaComponent(0.3)
            referenceLines.referenceLineLabelColor = color
            dotPlot.dataPointFillColor = color
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        graphView = ScrollableGraphView(frame: frame, dataSource: self)
        
        linePlot.lineWidth = 1
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        dotPlot.dataPointSize = 2
        
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.clear
        
        referenceLines.positionType = .absolute
        referenceLines.absolutePositions = [10, 20, 25, 30]
        referenceLines.includeMinMax = false
        
        referenceLines.dataPointLabelColor = UIColor.white
        
        graphView.backgroundFillColor = UIColor.clear
        graphView.dataPointSpacing = 80
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        graphView.rangeMax = 50
        
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
        graphView.translatesAutoresizingMaskIntoConstraints = false
        
        titleGraphlabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleGraphlabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleGraphlabel)
        addSubview(graphView)
        
        addConstraintsWithFormat(visualFormat: "H:|[v0]|", views: graphView)
        addConstraintsWithFormat(visualFormat: "H:|-[v0]-|", views: titleGraphlabel)
        addConstraintsWithFormat(visualFormat: "V:|-[v0(30)]-[v1]-|", views: titleGraphlabel, graphView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension IGChartViewCell: ScrollableGraphViewDataSource {
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        return Double(points[pointIndex])
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return data[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return data.count
    }
    
}
