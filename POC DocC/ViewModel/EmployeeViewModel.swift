//
//  AssignmentViewModel.swift
//  Assignment
//
//  Created by Vijay Arora on 20-10-2023.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import UIKit

enum GroupBy {
    case name
    case team
}

protocol EmployeeViewOutputDelegate {
    func show(message: String)
    func reloadUI()
}

/// EmployeeViewDelegate
protocol EmployeeViewDelegate {

    /// init with ``EmployeeViewOutputDelegate``
    /// - Parameter delegate: ``EmployeeViewOutputDelegate`` instance
    init(delegate: EmployeeViewOutputDelegate)
    /// Load employees
    func loadEmployee()
    /// Return number of sections
    /// - Returns: Number of sections
    func numberOfSections() -> Int
    /// Return numberOfRows in particular section
    /// - Parameter section: Section index
    /// - Returns: NumberOfRows in particular section
    func numberOfRows(at section: Int) -> Int
    /// Return employee object at particular indexpath
    /// - Parameter indexPath: IndexPath
    /// - Returns: Employee object at particular indexpath
    func object(at indexPath: IndexPath) -> Employee?
    /// This method group the list by `name` or `team`
    /// - Parameter type: `name` or `team`
    func groupBy(type: GroupBy)
    /// Return title for header in section
    /// - Parameter section: Section index
    /// - Returns: Title for header in section
    func titleForHeaderInSection(at section: Int) -> String
}

/// `EmployeeViewModel` class design to peform all business login initiated by``ListViewController``
class EmployeeViewModel: EmployeeViewDelegate {
    
    /// Employee list
    var dataList = [Employee]()
    /// Observable error message
    var errorMessage = Dynamic<String>("")
    /// ``EmployeeViewOutputDelegate`` instance
    private var delegate: EmployeeViewOutputDelegate!
    /// ``GroupBy`` value
    private var type: GroupBy = .name
    /// Employee list by group
    private var group = [String: [Employee]]()
    /// Section header list
    private var sections = [String]()
    
    /// init with ``EmployeeViewOutputDelegate``
    /// - Parameter delegate: ``EmployeeViewOutputDelegate`` instance
    required init(delegate: EmployeeViewOutputDelegate) {
        self.delegate = delegate
    }
    
    /// Load employees
    func loadEmployee() {
        delegate.show(message: StringConstants.loading)
        guard let url = URL(string: API.getEmployees.getURL()) else { return }
        let request = APIRequest(url: url)
        request.perform { [weak self] (model: EmployeeModel?, error: String?) in
            guard let self = self, let model = model else { return }
            if let list = model.employees, list.count > 0 {
                self.dataList = list
                self.groupBy(type: .name)
            } else {
                self.delegate.show(message: StringConstants.notDataMessage)
            }
        }
    }
    
    /// Return number of sections
    /// - Returns: number of sections
    func numberOfSections() -> Int {
        return group.count
    }
    
    /// Return numberOfRows in particular section
    /// - Parameter section: Section index
    /// - Returns: NumberOfRows in particular section
    func numberOfRows(at section: Int) -> Int {
        let key = sections[section]
        return group[key]?.count ?? 0
    }
    
    /// Return employee object at particular indexpath
    /// - Parameter indexPath: IndexPath
    /// - Returns: Employee object at particular indexpath
    func object(at indexPath: IndexPath) -> Employee? {
        let key = sections[indexPath.section]
        return group[key]?[indexPath.row]
    }
    
    /// This method group the list by `name` or `team`
    /// - Parameter type: `name` or `team`
    func groupBy(type: GroupBy) {
        if type == .name {
            var nameDictionary = [String: [Employee]]()
            for employeee in dataList {
                if let name = employeee.fullName {
                    let nameKey = String(name.prefix(1))
                    if var nameValues = nameDictionary[nameKey] {
                        nameValues.append(employeee)
                        nameDictionary[nameKey] = nameValues
                    } else {
                        nameDictionary[nameKey] = [employeee]
                    }
                }
            }
            self.group = nameDictionary
        } else {
            self.group = Dictionary(grouping: dataList, by: { $0.team  ?? ""})
        }
        sections = Array(group.keys).sorted(by: { $0 < $1 })
        delegate.reloadUI()
    }
    
    /// Return title for header in section
    /// - Parameter section: Section index
    /// - Returns: Title for header in section
    func titleForHeaderInSection(at section: Int) -> String {
        let title = sections[section]
        let index = title.index(title.startIndex, offsetBy: 0)
        return String(title[index]).uppercased()
    }
}
