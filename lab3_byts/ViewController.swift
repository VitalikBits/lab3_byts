//
//  ViewController.swift
//  lab3_byts
//
//  Created by stud on 24.09.2026.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var genderPickerView: UIPickerView!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    let genders = ["Чоловіча", "Жіноча"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        genderPickerView.delegate = self
        
        genderPickerView.dataSource = self
        
        loadUserData()
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {

        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let surname = surnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let ageText = ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // Перевіряємо, чи всі поля заповнені
        guard !name.isEmpty, !surname.isEmpty, !ageText.isEmpty else {
            showAlert(message: "Будь ласка, заповніть усі поля анкети.")
            return
        }

        // Перевіряємо правильність віку
        guard let age = Int(ageText), age > 0, age <= 120 else {
            showAlert(message: "Введіть коректний вік від 1 до 120.")
            return
        }

        let selectedRow = genderPickerView.selectedRow(inComponent: 0)
        let gender = genders[selectedRow]
        let notifications = notificationSwitch.isOn

        print("===== АНКЕТА КОРИСТУВАЧА =====")
        print("Ім'я: \(name)")
        print("Прізвище: \(surname)")
        print("Вік: \(age)")
        print("Стать: \(gender)")
        print("Сповіщення: \(notifications ? "Увімкнені" : "Вимкнені")")

        showAlert(message: "Анкету успішно перевірено!")
        
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(surname, forKey: "userSurname")
        UserDefaults.standard.set(age, forKey: "userAge")
        UserDefaults.standard.set(gender, forKey: "userGender")
        UserDefaults.standard.set(notifications, forKey: "userNotifications")
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Анкета користувача",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true)
    }
    
    func loadUserData() {
        let defaults = UserDefaults.standard

        nameTextField.text = defaults.string(forKey: "userName")
        surnameTextField.text = defaults.string(forKey: "userSurname")

        if defaults.object(forKey: "userAge") != nil {
            ageTextField.text = String(defaults.integer(forKey: "userAge"))
        }

        if let savedGender = defaults.string(forKey: "userGender"),
           let index = genders.firstIndex(of: savedGender) {
            genderPickerView.selectRow(index, inComponent: 0, animated: false)
        }

        if defaults.object(forKey: "userNotifications") != nil {
            notificationSwitch.isOn = defaults.bool(forKey: "userNotifications")
        }
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return genders[row]
    }
}
