//
//  HomeViewController.swift
//  alvingro
//
//  Created by Thành Nguyên on 20/05/2021.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var voucherCollectionView: UICollectionView!
    @IBOutlet weak var highlyRecommendedCollectionView: UICollectionView!
    @IBOutlet weak var bestSellingCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var groceriesCollectionView: UICollectionView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var voucherPageControl: CustomPageControl!
    
    //MARK: - Variables
    lazy var viewModel = HomeViewModel(delegate: self)
    var refreshControl = UIRefreshControl()
    
    //MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupView() {
        tabBarController?.tabBar.unselectedItemTintColor = .black
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        voucherCollectionView.delegate = self
        voucherCollectionView.dataSource = self
        voucherCollectionView.register(VoucherCollectionViewCell.nib, forCellWithReuseIdentifier: VoucherCollectionViewCell.identifier)
        voucherCollectionView.allowsSelection = false
        
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
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.searchViewTapped))
        searchView.addGestureRecognizer(gesture)

        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        contentScrollView.insertSubview(refreshControl, at: 0)
    }
    
    
    //Download data from firebase
    func runRefresh(after wait: TimeInterval, closure: @escaping () -> Void) {
        self.viewModel.downloadDataFromFirebase()
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    //MARK: - Action
    @IBAction func seeAllHighlyRecommendedButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            guard let vc = storyboard?.instantiateViewController(identifier: SeeAllViewController.identifier) as? SeeAllViewController else { return }
            vc.initValue(keyWord: "HighlyRecommended")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func seeAllBestSellingButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            guard let vc = storyboard?.instantiateViewController(identifier: SeeAllViewController.identifier) as? SeeAllViewController else { return }
            vc.initValue(keyWord: "BestSelling")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func seeAllGroceriesButtonTapped(_ sender: Any) {
        if #available(iOS 13.0, *) {
            guard let vc = storyboard?.instantiateViewController(identifier: SeeAllViewController.identifier) as? SeeAllViewController else { return }
            vc.initValue(keyWord: "All")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func searchViewTapped(sender : UITapGestureRecognizer) {
        tabBarController?.selectedIndex = 1
    }
    
    //Action refresh of scroll view
    @objc func onRefresh() {
        runRefresh(after: 5) {
            self.viewModel.getAllProductFromDevice()
            self.refreshControl.endRefreshing()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case voucherCollectionView:
            voucherPageControl.numberOfPages = viewModel.vouchersList.count
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
            cell.setColor(index: indexPath.row)
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            if #available(iOS 13.0, *) {
                guard let vc = storyboard?.instantiateViewController(identifier: SeeAllViewController.identifier) as? SeeAllViewController else { return }
                vc.initValue(keyWord: viewModel.categoriesList[indexPath.row].id ?? "")
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if #available(iOS 13.0, *) {
            guard let vc = self.storyboard?.instantiateViewController(identifier: DetailsViewController.identifier) as? DetailsViewController else { return }
            switch collectionView {
            case highlyRecommendedCollectionView:
                vc.initValue(product: viewModel.highlyRecommendedList[indexPath.row])
            case bestSellingCollectionView:
                vc.initValue(product: viewModel.bestSellingList[indexPath.row])
            case groceriesCollectionView:
                vc.initValue(product: viewModel.groceriseList[indexPath.row])
            default:
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            return
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == voucherCollectionView {
            voucherPageControl.currentPage = indexPath.row
        }
    }
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
        default: // return width of ProductCollectionViewCell
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
