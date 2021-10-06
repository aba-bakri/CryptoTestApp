//
//  AppDelegate.swift
//  CryptoCurrencyTestApp
//
//  Created by Aba-Bakri Ibragimov on 1/10/21.
//

import UIKit

protocol ChooseCryptoDelegate {
    func didSelect(symbolsModel: SymbolModel)
}

class ChooseCryptoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    let viewModel = ChooseCryptoViewModel()
    var symbolsModel: [SymbolModel] = []
    var delegate: ChooseCryptoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllSymbols()
    }
    
    private func getAllSymbols() {
        self.showActivityIndicator()
        viewModel.getAllSymbols { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                for i in response {
                    if i.price != nil {
                    self.symbolsModel.append(i)
                    }
                }
                self.dismissActivityIndicator()
                //self.symbolsModel = response
                self.tableView.reloadData()
            case .failure(let err):
                print(err)
            }
        }
    }
}

extension ChooseCryptoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symbolsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(symbolsModel[indexPath.row].asset_id_base ?? "")/\(symbolsModel[indexPath.row].asset_id_quote ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(symbolsModel: symbolsModel[indexPath.row])
        dismiss(animated: true)
    }
}
