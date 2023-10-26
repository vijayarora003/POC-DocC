//
//  AssignmentViewController.swift
//  Assignment
//
//  Created by Vijay Arora on 20-10-2023.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController  {
    
    @IBOutlet private weak var loadingWarningLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var viewModel: EmployeeViewModel!
    
    /// Called after the view controller’s view has been loaded into memory.
    ///
    /// You can override this method to perform tasks to immediately follow the setting of the view property.
    ///
    /// Typically, your override would perform one-time instantiation and initialization of the contents of the view controller’s view. If you override this method, call this method on super at some point in your implementation in case a superclass also overrides this method.
    ///
    /// For a view controller originating in a nib file, this method is called immediately after the view property is set. For a view controller created programmatically, this method is called immediately after the loadView() method completes.
    ///
    /// The default implementation of this method does nothing.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPUI()
    }
    
    /// This method called to initialize UI
    func setUPUI() {
        viewModel = EmployeeViewModel(delegate: self)
        viewModel.loadEmployee()
        tableView.registerCell(EmployeeTableViewCell.self)
        tableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    /// This method use to group list by `name` or `team`
    /// - Parameter sender: `UIBarButtonItem`
    ///
    ///  This mehod use to group list by `name` or `team`. This mehod presents actionsheet to choose group by `name` or `team`
    ///
    /// ```swift
    ///   enum GroupBy {
    ///      case name
    ///      case team
    ///    }
    /// ```
    @IBAction func groupByButtonAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: StringConstants.GroupBy, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: StringConstants.name, style: .default) { [weak self] (a) in
            self?.viewModel.groupBy(type: .name)
        })
        
        alert.addAction(UIAlertAction(title:  StringConstants.team, style: .default) { [weak self] (a) in
            self?.viewModel.groupBy(type: .team)
        })
        
        alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel , handler: nil))
        alert.popoverPresentationController?.sourceView = sender.customView
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        viewModel.loadEmployee()
    }
}

extension ListViewController: EmployeeViewOutputDelegate {
    
    func show(message: String) {
        loadingWarningLabel.isHidden = false
        loadingWarningLabel.text = message
    }
    
    func reloadUI() {
        self.loadingWarningLabel.isHidden = viewModel.numberOfSections() > 0
        self.refreshControl.endRefreshing()
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDataSource {
    
    /// Asks the data source to return the number of sections in the table view.
    /// - Parameter tableView: An object representing the table view requesting this information.
    /// - Returns: The number of sections in tableView.
    ///
    /// If you don’t implement this method, the table configures the table with one section.
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    
    /// Tells the data source to return the number of rows in a given section of a table view.
    /// - Parameters:
    ///   - tableView: The table-view object requesting this information.
    ///   - section: An index number identifying a section in tableView.
    /// - Returns: The number of rows in section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(at: section)
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view.
    /// - Parameters:
    ///   - tableView: A table-view object requesting the cell.
    ///   - indexPath: An index path locating a row in tableView.
    /// - Returns: An object inheriting from `UITableViewCell` that the table view can use for the specified row. UIKit raises an assertion if you return nil.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(with: EmployeeTableViewCell.self, indexPath: indexPath)
        cell.model = viewModel.object(at: indexPath)
        return cell
    }
    
    /// Asks the data source for the title of the header of the specified section of the table view.
    /// - Parameters:
    ///   - tableView: The table-view object asking for the title.
    ///   - section: An index number identifying a section of tableView.
    /// - Returns: A string to use as the title of the section header. If you return nil , the section will have no title.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(at: section)
    }
}

extension ListViewController: UITableViewDelegate {
    
    /// Asks the delegate for the height to use for a row in a specified location.
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - indexPath: An index path that locates a row in tableView.
    /// - Returns: A nonnegative floating-point value that specifies the height (in points) that row should be.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 50
        return UITableView.automaticDimension
    }
}


