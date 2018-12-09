//
//  UserProfileHeader.swift
//  Instgram
//
//  Created by Mahmoud Mohammed on 10/12/18.
//  Copyright © 2018 Mahmoud Mohammed. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {

  var user: User? {
    didSet{
      guard let profileImageUrl = user?.profileImageUrl else { return }
      profileImageView.loadImage(urlString: profileImageUrl)

      setupEditFollowButton()

      usernameLbl.text = user?.username
    }
  }

  fileprivate func setupEditFollowButton() {
    guard let currentLoggedInUserID = Auth.auth().currentUser?.uid else { return }

    guard let userId = user?.uid else { return }

    if currentLoggedInUserID == userId {
      // Edit profile logic
    } else {

      // check if following
      Database.database().reference().child("following").child(currentLoggedInUserID).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
        if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
          self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        } else {
          self.editProfileFollowButton.setTitle("Follow", for: .normal)
          self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17,green: 154,blue: 237)
          self.editProfileFollowButton.setTitleColor(.white, for: .normal)
          self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        }
      }) { (err) in
        print("Failed to check if following:", err)
      }

    }
  }

  @objc func handleEditProfileOrFollow() {
    guard let currentLoggedInUserID = Auth.auth().currentUser?.uid else { return }

    guard let userId = user?.uid else { return }

    let ref = Database.database().reference().child("following").child(currentLoggedInUserID)

    let values = [userId: 1]
    ref.updateChildValues(values) { (err, ref) in
      if let err = err {
        print("Failed to follow user:", err)
      }

      print("Successfully followed user:", self.user?.username ?? "")
    }
  }

  let profileImageView: CustomImageView = {
    let iv = CustomImageView()
    return iv
  }()

  let gridButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "grid"), for: .normal)
    return button
  }()

  let listButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "list"), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    return button
  }()

  let bookmarkButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: "ribbon"), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    return button
  }()

  let usernameLbl: UILabel = {
    let label = UILabel()
    label.text = "username"
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
  }()

  let postsLbl: UILabel = {
    let label = UILabel()

    let attributedText = NSMutableAttributedString(string: "11\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                                                                           NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
    label.attributedText = attributedText

    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()

  let followersLbl: UILabel = {
    let label = UILabel()

    let numberAttributes: [NSAttributedStringKey: Any] = [
      .strokeColor : UIColor.black,
      .foregroundColor : UIColor.white,
      .strokeWidth : -2.0,
      .font : UIFont.boldSystemFont(ofSize: 18)
    ]

    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                                                                               NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
    label.attributedText = attributedText

    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()

  let followingLbl: UILabel = {
    let label = UILabel()

    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                                                                               NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
    label.attributedText = attributedText

    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()

  lazy var editProfileFollowButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Edit Profile", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 3
    button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(profileImageView)
    profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
    profileImageView.layer.cornerRadius = 80 / 2
    profileImageView.clipsToBounds = true

    setupBottomToolbar()

    addSubview(usernameLbl)
    usernameLbl.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)

    setupUserStatusView()
  }

  fileprivate func setupUserStatusView() {
    let stackView = UIStackView(arrangedSubviews: [postsLbl, followersLbl, followingLbl])

    stackView.axis = .horizontal
    stackView.distribution = .fillEqually

    addSubview(stackView)
    stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)

    addSubview(editProfileFollowButton)
    editProfileFollowButton.anchor(top: postsLbl.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: followingLbl.rightAnchor, paddingTop: 2, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)

  }

  fileprivate func setupBottomToolbar() {
    let topDividerView = UIView()
    topDividerView.backgroundColor = UIColor.lightGray

    let bottomDividerView = UIView()
    bottomDividerView.backgroundColor = UIColor.lightGray

    let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])

    stackView.axis = .horizontal
    stackView.distribution = .fillEqually

    addSubview(stackView)
    addSubview(topDividerView)
    addSubview(bottomDividerView)

    stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)

    topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)

    bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
