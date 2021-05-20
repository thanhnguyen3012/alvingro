//
//  HomeViewController.swift
//  alvingro
//
//  Created by Thành Nguyên on 20/05/2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var voucherCollectionView: UICollectionView!
    @IBOutlet weak var highlyRecommendedCollectionView: UICollectionView!
    @IBOutlet weak var bestSellingCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var groceriesCollectionView: UICollectionView!
    
    lazy var viewModel = HomeViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        
        voucherCollectionView.delegate = self
        voucherCollectionView.dataSource = self
        voucherCollectionView.register(VoucherCollectionViewCell.nib, forCellWithReuseIdentifier: VoucherCollectionViewCell.identifier)
        
        highlyRecommendedCollectionView.delegate = self
        highlyRecommendedCollectionView.dataSource = self
        highlyRecommendedCollectionView.register(ProductCollectionViewCell.nib, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
        bestSellingCollectionView.delegate = self
        bestSellingCollectionView.dataSource = self
        bestSellingCollectionView.register(ProductCollectionViewCell.nib, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(HomeCategoryCollectionViewCell.nib, forCellWithReuseIdentifier: HomeCategoryCollectionViewCell.identifier)
        
        groceriesCollectionView.delegate = self
        groceriesCollectionView.dataSource = self
        groceriesCollectionView.register(ProductCollectionViewCell.nib, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
        /// Components of navigationBar
        let logoApp = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        logoApp.image = UIImage(named: "Logo2")
        
        let positionButton = UIButton(frame: CGRect(x: 0, y: 0, width: (self.view.frame.width - 20), height: 21))
        positionButton.titleLabel?.text = viewModel.getCurrentPosition()
        positionButton.setTitleColor(.darkGray, for: .normal)
        positionButton.setImage(UIImage(named: "Exclude"), for: .normal)
        
        let searchBar = UISearchBar(frame: CGRect(x: 20, y: 0, width: (self.view.frame.width - 40), height: 52))
        searchBar.layer.cornerRadius = 15
        searchBar.image(for: .search, state: .normal)
        searchBar.placeholder = "Search Store"
        
        let stackHeader = UIStackView(arrangedSubviews: [logoApp, positionButton, searchBar])
        stackHeader.distribution = .equalCentering
        stackHeader.axis = .vertical
        stackHeader.alignment = .center
        
        self.tabBarController?.navigationItem.titleView = searchBar
    }
    
    
    @IBAction func seeAllHighlyRecommendedButtonTapped(_ sender: Any) {
    }
    
    @IBAction func seeAllBestSellingButtonTapped(_ sender: Any) {
    }
    
    @IBAction func seeAllGroceriesButtonTapped(_ sender: Any) {
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case voucherCollectionView:
            return viewModel.vouchersList.count
        case highlyRecommendedCollectionView:
            return viewModel.highlyRecommendedList.count
        case bestSellingCollectionView:
            return viewModel.bestSellingList.count
        case categoriesCollectionView:
            return viewModel.categoriesList.count
        default: //groceriesCollectionViewCell
            return (collectionView == groceriesCollectionView) ? viewModel.groceriseList.count : 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case voucherCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VoucherCollectionViewCell.identifier, for: indexPath) as? VoucherCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.bindData(voucher: viewModel.vouchersList[indexPath.row])
            return cell
        case categoriesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCollectionViewCell.identifier, for: indexPath) as? HomeCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.bindData(category: viewModel.categoriesList[indexPath.row])
            return cell
        default:
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
                return UICollectionViewCell()
            }
            switch collectionView {
            case highlyRecommendedCollectionView:
                cell.bindData(product: viewModel.highlyRecommendedList[indexPath.row])
            case bestSellingCollectionView:
                cell.bindData(product: viewModel.bestSellingList[indexPath.row])
            default: // Groceries Collection View
                cell.bindData(product: viewModel.groceriseList[indexPath.row])
            }
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 0, height: collectionView.frame.height)
        switch collectionView {
        case voucherCollectionView:
            size.width = collectionView.frame.width
            break
        case categoriesCollectionView:
            size.width = 248
        default:
            size.width = 173
        }
        return size
    }
}

extension HomeViewController: HomeViewModelEvents {
    func loadedProducts() {
        highlyRecommendedCollectionView.reloadData()
        bestSellingCollectionView.reloadData()
        voucherCollectionView.reloadData()
        categoriesCollectionView.reloadData()
        groceriesCollectionView.reloadData()
    }
}
