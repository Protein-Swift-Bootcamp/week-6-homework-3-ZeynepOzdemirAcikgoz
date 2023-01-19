
 
 //
 //  ViewController.swift
 //  BooksApp
 //
 //  Created by Zeynep Özdemir Açıkgöz on 13.01.2023.
 //

 import UIKit

 class ViewController: UIViewController {
     
     @IBOutlet weak var collectionView: UICollectionView!
     
     var collectionViewFlowLayout: UICollectionViewFlowLayout!
     let cellIdentifier = "BookItemCollectionViewCell"
     
     
     private var books = [Book]()
     private var viewModels = [BookTableViewCellModel]()
     
     override func viewDidLoad() {
         super.viewDidLoad()
      
         collectionView.delegate = self
         collectionView.dataSource = self
         collectionView.reloadData()
         self.collectionView.register(UINib(nibName: BookItemCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BookItemCollectionViewCell.identifier)
         
         
         fetchTopBooks()
     }
     
     override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
         setUpColletionViewItemSize()
     }
     
     private func fetchTopBooks(){
         APICaller.shared.getTrendingBooks{ [weak self] result in
             switch result{
             case.success(let books):
                 self?.books = books
                 self?.viewModels  = books.compactMap({ viewModels in
                     BookTableViewCellModel(yazar: viewModels .yazar ?? "", title: viewModels .title ?? "", imageUrl: URL(string: viewModels.image ?? ""))
                 })
                 
                 DispatchQueue.main.async {
                     self?.collectionView.reloadData()
                 }
             case.failure(let error):
                 print(error)
             }
         }
     }
     
     
     private func setUpColletionViewItemSize(){
         //        if collectionViewFlowLayout == nil {
         //                              let numberofItemPerRow: CGFloat = 2
         //                              let lineSpacing: CGFloat = 5
         //                              let internItemSpacing: Float = 2
         //
         //                              let width = (collectionView.frame.width - (numberofItemPerRow - 1) * CGFloat(internItemSpacing) ) / numberofItemPerRow
         //                              let height = width
         //                              collectionViewFlowLayout = UICollectionViewFlowLayout()
         //                              collectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
         //
         //                              collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
         //                              collectionViewFlowLayout.scrollDirection = .vertical
         //                              collectionViewFlowLayout.minimumLineSpacing = lineSpacing
         //                              collectionViewFlowLayout.minimumInteritemSpacing = CGFloat(internItemSpacing)
         //
         //                              collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
         //                          }
         let pinterestLayout = PinterestLayout()
         pinterestLayout.delegate = self
         collectionView.collectionViewLayout = pinterestLayout
         
     }
     
 }

 extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return books.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         view.backgroundColor = .systemGray
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookItemCollectionViewCell.identifier, for: indexPath) as? BookItemCollectionViewCell else  {
             return UICollectionViewCell()
         }
         
         cell.configure(with: viewModels[indexPath.item])
         //cell.backgroundColor = .systemGray
         cell.clipsToBounds = true
         cell.layer.cornerRadius = 20
        
         return cell
         
     }
     
 }

 extension ViewController : UICollectionViewDelegateFlowLayout {
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         
         return .init(width: collectionView.frame.width/0.5, height: collectionView.frame.height/0.5)
     }
 }

 extension ViewController: PinterestLayoutDelegate{
     func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
         return 180
     }
     
     func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
         let post = books[indexPath.item]
         let captionFont = UIFont.systemFont(ofSize: 10)
         let captionHeight = Dizayn.shared.height(for:post.image! , with: captionFont, width: width)
         let height = (captionHeight * 2) + 32
         return height
         
     }
     
 }
     class Dizayn {
         static let shared = Dizayn()
         
         func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat
         {
             let nsstring = NSString(string: text)
             let maxHeight = CGFloat(MAXFLOAT)//alabileceği maximumum değer
             let textAttributes = [NSAttributedString.Key.font : font]
             let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
             return ceil(boundingRect.height)
         }
     
     
     
 }

