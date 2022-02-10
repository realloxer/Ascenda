//
//  SearchContactsViewController.swift
//  Ascenda
//
//  Created by LocNguyen on 10/02/2022.
//

import UIKit

final class SearchContactsViewController: UIViewController {

    var viewModel: SearchContactsViewModel!
    @IBOutlet weak var noContactLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.onViewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

}

extension SearchContactsViewController: SearchContactsViewModelDelegate {
    func didFetchedContacts(_ contacts: [Contact]) {
        DispatchQueue.main.async {
            self.tableView.isHidden = contacts.isEmpty
            self.noContactLabel.isHidden = !contacts.isEmpty
            if !contacts.isEmpty {
                self.tableView.reloadData()
            }
        }
    }
    
    func didLoadMoreContacts(_ contacts: [Contact]) {
    }
    
}

extension SearchContactsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as? ContactTableViewCell {
            cell.display(viewModel.contactAt(index: indexPath.row), searchText: viewModel.currentSearchText)
            return cell
        }
        return UITableViewCell()
    }
}

extension SearchContactsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchContacts(searchText: searchBar.text)
        searchBar.resignFirstResponder()
    }
    
}
