//
//  FeedCollectionViewCell.swift
//  FindYourFace
//
//  Created by Roman on 9/6/20.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {

    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            print(data.name)
            if !(data.profileImageUrl == "") {
                ImageNetworking().downloadImage(from: URL(string: data.profileImageUrl)!) { (image, error) in
                    self.profileImageView.image = image
                }
            } else {
                self.profileImageView.image = UIImage(named: "cat")
            }
            ImageNetworking().downloadImage(from: URL(string: data.mainImageUrl)!) { (image, error) in
                self.mainImageView.image = image
            }
            nameLabel.text = data.name
            typeLabel.text = data.type
            timeLabel.text = Date(timeIntervalSince1970: TimeInterval(exactly: Double(data.time)!)!).timeAgoDisplay()
            setupCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Black", size: 15.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let typeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: "Lato", size: 15.0)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato", size: 15.0)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    func setupCell() {
        
        contentView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 46).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 10).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: self.profileImageView.rightAnchor,constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.profileImageView.topAnchor).isActive = true
        
        contentView.addSubview(typeLabel)
        typeLabel.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor).isActive = true
        typeLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 3).isActive = true
        
    
        contentView.addSubview(mainImageView)
        mainImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor,constant: -20).isActive = true
        mainImageView.leftAnchor.constraint(equalTo: self.profileImageView.leftAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor,constant: 20).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
        
        contentView.addSubview(timeLabel)
        timeLabel.rightAnchor.constraint(equalTo: self.mainImageView.rightAnchor).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.typeLabel.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Date {
    func timeAgoDisplay() -> String {
    let secondsAgo = Int(Date().timeIntervalSince(self))
    
    let minute = 60
    let hour = 60 * minute
    let day = 24 * hour
    let week = 7 * day

    if secondsAgo < minute {
        return "\(secondsAgo) sec ago"
    } else if secondsAgo < hour {
        return "\(secondsAgo / minute) min ago"
    } else if secondsAgo < day {
        return "\(secondsAgo / hour) hrs ago"
    } else if secondsAgo < week {
        return "\(secondsAgo / day) days ago"
    }

    return "\(secondsAgo / week) weeks ago"
    }
}
