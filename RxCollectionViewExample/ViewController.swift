//
//  ViewController.swift
//  RxCollectionViewExample
//
//  Created by Alper Akinci on 28/12/2017.
//  Copyright © 2017 Alper Akinci. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class CountryCell : UICollectionViewCell {
    @IBOutlet var countryLabel: UILabel?
}

class CountrySectionView : UICollectionReusableView {
    @IBOutlet weak var countrySectionLabel: UILabel?
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
        let (cell, section) = ViewController.collectionViewDataSourceUI()
        let dataSource = RxCollectionViewSectionedReloadDataSource(configureCell: cell,
                                                                   configureSupplementaryView: section)

        let dummyData = [
            CountrySection(header: "Europe", countries: ["Germany", "Czech Republic", "Austria", "France"]),
            CountrySection(header: "Asia", countries: ["Vietnam", "Thailand", "Malaysia"])
            ]

        Observable.just(dummyData)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }


}

extension ViewController {

    static func collectionViewDataSourceUI() -> (
        CollectionViewSectionedDataSource<CountrySection>.ConfigureCell,
        CollectionViewSectionedDataSource<CountrySection>.ConfigureSupplementaryView
        ) {
            return (
                { (_, cv, ip, i) in
                    let cell = cv.dequeueReusableCell(withReuseIdentifier: "Cell", for: ip) as! CountryCell
                    cell.countryLabel!.text = "\(i)"
                    return cell

            },
                { (ds ,cv, kind, ip) in
                    let section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Section", for: ip) as! CountrySectionView
                    section.countrySectionLabel!.text = "\(ds[ip.section].header)"
                    return section
            }
            )
    }

}

