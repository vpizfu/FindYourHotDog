//
//  FeedViewController.swift
//  FindYourFace
//
//  Created by Roman on 9/6/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    lazy var presenter = FeedViewControllerPresenter(with: self)
    
    var myCollectionView:UICollectionView?
    var dataArray = [CustomData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view?.fetchDataForCollectionView()
        setupCollectionView()
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
    }
    
}

//MARK:- UI Configuration
extension FeedViewController {
    func setupCollectionView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        view.addSubview(myCollectionView ?? UICollectionView())
        
        self.view = view
    }
}

//MARK: - Presenter Protocol Declaration
extension FeedViewController: FeedViewControllerPresenterView {
    func fetchDataForCollectionView() {
        DispatchQueue.global().async {
            ImageNetworking().fetchDataFromFirebase { (data) in
                self.dataArray = data
                print(data.count)
                DispatchQueue.main.async {
                    self.myCollectionView?.reloadData()
                }
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! FeedCollectionViewCell
        myCell.profileImageView.image = UIImage(named: "cat")
        myCell.mainImageView.image = UIImage(named: "defaultCellBackground")
        if (dataArray.count != 0) {
            myCell.data = dataArray[indexPath.row]
        }
        return myCell
    }
}

//MARK: - UICollectionViewDelegate
extension FeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: view.frame.width, height: view.frame.width + 100)
    }
}
