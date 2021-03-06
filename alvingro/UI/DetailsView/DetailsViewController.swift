//
//  DetailsViewController.swift
//  alvingro
//
//  Created by Thành Nguyên on 28/05/2021.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var expandDetailsButton: UIButton!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var expandNutritionButton: UIButton!
    @IBOutlet weak var nutritionTextView: UITextView!
    @IBOutlet weak var expandReviewButton: UIButton!
    @IBOutlet var ratingStarsArrayImageView: [UIImageView]!
    @IBOutlet weak var addToBasketButton: UIButton!
    @IBOutlet weak var photosPageControl: UIPageControl!
    
    // MARK: - Variables
    lazy var viewModel = DetailsViewModel(delegate: self)
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if #available(iOS 13.0, *) {
            let navigationBarAppearence = UINavigationBarAppearance()
            navigationBarAppearence.shadowColor = .clear
            navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearence
        }
        navigationItem.backButtonTitle = ""
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.register(DetailsCollectionViewCell.nib, forCellWithReuseIdentifier: DetailsCollectionViewCell.identifier)
        photosCollectionView.layer.cornerRadius = 25
        photosCollectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        productNameLabel.text = viewModel.product.name
        
        loveButton.setImage(UIImage(named: "Love-highlighted"), for: .selected)
        loveButton.setImage(UIImage(named: "Love"), for: .normal)
        loveButton.isSelected = viewModel.getStateOfLoveButton()
        
        unitLabel.text = viewModel.product.unit
        
        decreaseButton.setImage(UIImage(named: "Minus-active"), for: .normal)
        decreaseButton.setImage(UIImage(named: "Minus-unactive"), for: .disabled)
        
        increaseButton.setImage(UIImage(named: "Plus-active"), for: .normal)
        increaseButton.setImage(UIImage(named: "Plus-unactive"), for: .disabled)
        
        amountLabel.layer.cornerRadius = 17
        amountLabel.layer.borderWidth = 1
        amountLabel.layer.borderColor = UIColor.gray.cgColor
        
        priceLabel.text = "$\(viewModel.product.price)"
        
        expandDetailsButton.setImage(UIImage(named: "Next"), for: .normal)
        expandDetailsButton.setImage(UIImage(named: "Dropdown"), for: .selected)
        
        detailsTextView.text = viewModel.product.details
        detailsTextView.sizeToFit()
        detailsTextView.isHidden = true
        
        expandNutritionButton.setImage(UIImage(named: "Next"), for: .normal)
        expandNutritionButton.setImage(UIImage(named: "Dropdown"), for: .selected)
        
        nutritionTextView.text = viewModel.getNutritionString()
        nutritionTextView.sizeToFit()
        nutritionTextView.isHidden = true
        
        expandReviewButton.setImage(UIImage(named: "Next"), for: .normal)
        
        setupRatingPoint(rating: viewModel.product.rate)
        
        addToBasketButton.mainButton()
    
        viewModel.validAmount()
    }
    
    func setupRatingPoint(rating: Float) {
        var point = rating
        let maxPoint = Float(ratingStarsArrayImageView.count)
        while point > maxPoint {
            point -= maxPoint
        }
        
        for i in 0..<Int(ratingStarsArrayImageView.count) {
            ratingStarsArrayImageView[i].image = i < Int(point) ? UIImage(named: "Star-highlighted") : UIImage(named: "Star")
        }
    }
    
    func initValue(product: Product) {
        viewModel.product = product
    }
    
    //MARK: - Actions
    
    @IBAction func loveButtonTapped(_ sender: Any) {
        loveButton.isSelected = !loveButton.isSelected
        viewModel.addToLikeList(isSelected: loveButton.isSelected)
    }
    
    @IBAction func decreaseButtonTapped(_ sender: Any) {
        viewModel.decreaseAmount()
    }
    
    @IBAction func increaseButtonTapped(_ sender: Any) {
        viewModel.increaseAmount()
    }
    
    @IBAction func expandDetailsButtonTapped(_ sender: Any) {
        expandDetailsButton.isSelected = !expandDetailsButton.isSelected
        detailsTextView.isHidden = !expandDetailsButton.isSelected
    }
    
    @IBAction func expandNutritionButtonTapped(_ sender: Any) {
        expandNutritionButton.isSelected = !expandNutritionButton.isSelected
        nutritionTextView.isHidden = !expandNutritionButton.isSelected
    }
    
    @IBAction func addToBasketButtonTapped(_ sender: Any) {
        viewModel.addToCart()
    }
}
 
extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photosPageControl.numberOfPages = viewModel.product.photos.count
        return viewModel.product.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailsCollectionViewCell.identifier, for: indexPath) as? DetailsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bindData(url: viewModel.product.photos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        photosPageControl.currentPage = indexPath.row
    }
}

extension DetailsViewController: DetailsViewModelEvents {
    func showNotification(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.viewModel.changeAmount(newValue: 1)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeAmountFail(message: String, disableIncreaseButton: Bool, disableDecreaseButton: Bool) {
        let alert = UIAlertController(title: "Changing amount fail.", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeAmount(amount: Int, disableIncreaseButton: Bool, disableDecreaseButton: Bool) {
        amountLabel.text = "\(amount)"
        increaseButton.isEnabled = !disableIncreaseButton
        decreaseButton.isEnabled = !disableDecreaseButton
    }
    
    
}
