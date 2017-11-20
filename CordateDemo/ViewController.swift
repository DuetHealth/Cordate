//
//  ViewController.swift
//  JidaiDemo
//
//  Created by James Power on 11/20/17.
//  Copyright © 2017 Duet Health. All rights reserved.
//

import Cordate
import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {

    private let label = UILabel()
    private let fieldLabel = UILabel()
    private let calendarButton = UIButton(type: .system)
    private let dateFormatter = DateFormatter()

    private var date = Date?.none

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        dateFormatter.dateFormat = "MM/dd/yyyy"

        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        calendarButton.backgroundColor = view.tintColor
        calendarButton.layer.cornerRadius = 5
        calendarButton.setTitle("Select Date".localizedUppercase, for: .normal)
        calendarButton.setTitleColor(.white, for: .normal)
        view.addSubview(calendarButton)
        NSLayoutConstraint.activate([
            calendarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -8),
            calendarButton.widthAnchor.constraint(equalToConstant: 200),
            calendarButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        calendarButton.addTarget(self, action: #selector(showCalendar), for: .touchUpInside)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Use the calendar to select a date"
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: calendarButton.topAnchor, constant: -8).isActive = true

        fieldLabel.translatesAutoresizingMaskIntoConstraints = false
        fieldLabel.text = "Date in field: nil"
        view.addSubview(fieldLabel)
        fieldLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 8).isActive = true
        fieldLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let field = ManualDateField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.dateDelegate = self
        field.textAlignment = .center
        view.addSubview(field)
        field.topAnchor.constraint(equalTo: fieldLabel.bottomAnchor, constant: 8).isActive = true
        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        field.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }

    @objc private func showCalendar() {
        let calendar = CalendarDateSelectionController(dataSource: CalendarDataSource(mode: .birthDate), title: NSLocalizedString("Birth Date", comment: ""), initialDate: date)
        calendar.delegate = self
        calendar.modalPresentationStyle = .custom
        present(calendar, animated: true)
    }

}

extension ViewController: CalendarDateSelectionControllerDelegate {

    func calendarController(_ controller: CalendarDateSelectionController, didSelectDate date: Date) {
        self.date = date
        label.text = "You selected \(dateFormatter.string(from: date))"
    }

}

extension ViewController: ManualDateFieldDelegate {

    func dateField(_ dateField: ManualDateField, didProduceDate date: Date?) {
        fieldLabel.text = "Date in field: \(date.map(String.init(describing:)) ?? "nil")"
    }

}
