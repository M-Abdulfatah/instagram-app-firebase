//
//  HomeController.swift
//  Instgram
//
//  Created by ASUGARDS on 11/8/18.
//  Copyright © 2018 Mahmoud Mohammed. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

  let cellId = "cellId"

  override init(collectionViewLayout layout: UICollectionViewLayout) {
    super.init(collectionViewLayout: layout)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(self, selector: #selector(handleRefreshing), name: SharePhotoController.updateFeedNotificationName, object: nil)

    collectionView?.backgroundColor = .white

    collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)

    let refreshController = UIRefreshControl()
    refreshController.addTarget(self, action: #selector(handleRefreshing), for: .valueChanged)
    collectionView?.refreshControl = refreshController

    setupNavigationItems()

    fetchAllPosts()
  }

  @objc func handleRefreshing() {
    posts.removeAll()
    fetchAllPosts()
  }

  fileprivate func fetchAllPosts() {
    fetchPosts()
    fetchFollowingUserIds()
  }

  fileprivate func fetchFollowingUserIds() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }

      userIdsDictionary.forEach({ (key, value) in
        Database.fetchUserWithID(uid: key, completion: { (user) in
          self.fetchPostsForUser(user: user)
        })
      })
    }) { (err) in
      print(err.localizedDescription)
    }
  }

  var posts = [Post]()
  fileprivate func fetchPosts() {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    Database.fetchUserWithID(uid: uid) { (user) in
      self.fetchPostsForUser(user: user)
    }
  }

  fileprivate func fetchPostsForUser(user: User) {
    let ref = Database.database().reference().child("posts").child(user.uid)
    ref.observeSingleEvent(of: .value, with: { (snapshot) in

      guard let dictionaries = snapshot.value as? [String: Any] else { return }

      dictionaries.forEach({ (key, value) in

        self.collectionView?.refreshControl?.endRefreshing()

        guard let dictionary = value as? [String: Any] else { return }

        let post = Post(user: user, dictionary: dictionary)
        self.posts.append(post)
      })

      self.posts.sort(by: {$0.creationDate > $1.creationDate})
      self.collectionView?.reloadData()

    }) { (err) in
      print("Faild to fetch posts: ", err.localizedDescription)
    }
  }
  func setupNavigationItems() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
  }

  @objc func handleCamera() {
    let cameraController = CameraController()
    present(cameraController, animated: true, completion: nil)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height: CGFloat = 40 + 8 + 8 // username userProfileImageView
    height += view.frame.width
    height += 50
    height += 80

    return CGSize(width: view.frame.width, height: height)
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
    cell.post = posts[indexPath.item]
    return cell
  }
}
