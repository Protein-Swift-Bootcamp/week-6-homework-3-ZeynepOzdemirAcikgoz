//
//  BookItemCollectionViewCell.swift
//  BooksApp
//
//  Created by Zeynep Özdemir Açıkgöz on 13.01.2023.
//

import UIKit

class BookItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookItemCollectionViewCell"

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var yazarLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with viewModel : BookTableViewCellModel){
        yazarLabel.text = viewModel.yazar
        titleLabel.text = viewModel.title
        //image cornerRadius verildi
        imageView.layer.cornerRadius = imageView.frame.height / 9

        
         //image
        if let data = viewModel.imageData {
            self.imageView.image = UIImage(data: data)
         }
        else if let url = viewModel.imageUrl {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else{
                    return
                }
                 //viewModel.imageData = data
                 DispatchQueue.main.async {
                     self?.imageView.image = UIImage(data: data)
                 }
             }.resume()
         }
        
        
    }
         

}
