//
//  ViewController.swift
//  DemoRealmBug
//
//  Created by Romain Penchenat on 20/12/2020.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var ui_realmFile: UILabel!
    @IBOutlet weak var ui_keyLabel: UILabel!
    @IBOutlet weak var ui_tableView: UITableView!
    var vault:Vault? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui_tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        ui_tableView.dataSource = self
    }

    @IBAction func importRealmAction(_ sender: Any) {
        let types = ["public.data", "public.realm", "public.item", "public.text"] as [String]
        let importMenu = UIDocumentPickerViewController(documentTypes: types, in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        if #available(iOS 13.0, *) {
            importMenu.directoryURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
        }
        present(importMenu, animated: true)
    }
    
    @IBAction func configureNewRealmAction(_ sender: Any) {
        vault?.reinitialize()
        vault = nil
        var key = Data(count: 64)
        _ = key.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
        }
        let config = Realm.Configuration(encryptionKey: key)
        removeRealmFile()
        let _realm = try! Realm(configuration: config)
        vault = Vault(withRealm: _realm)
        vault?.newCard(name: "First one \(Double.random(in: 0...100))", identifier: "my data", password: "password", notes: "notes")
        vault?.newCard(name: "Second one  \(Double.random(in: 0...100))", identifier: "my tagada", password: "password", notes: "notes")
        vault?.newCard(name: "Third one  \(Double.random(in: 0...100))", identifier: "heyho", password: "password", notes: "notes")
        setLabels(key: key.hexString, fileUrl: config.fileURL?.path)
        ui_tableView.reloadData()
    }
    
    func setLabels(key:String?, fileUrl:String?) {
        print("Key : \(key ?? "")")
        print("Realm file : \(fileUrl ?? "")")
        ui_keyLabel.text = "Key : \(key ?? "")"
        ui_realmFile.text = "Realm file : \(fileUrl ?? "")"
    }
    
    private func removeRealmFile() {
        let config = Realm.Configuration()
        if FileManager.default.fileExists(atPath: config.fileURL!.path) {
            try? FileManager.default.removeItem(at: config.fileURL!)
        }
    }
    
}

extension ViewController : UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        removeRealmFile()
        try! FileManager.default.copyItem(at: url, to: Realm.Configuration().fileURL!)
        let ac = UIAlertController(title: "Enter decryption key", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let key = ac.textFields![0].text ?? ""
            let config = Realm.Configuration(encryptionKey: Data.fromHexString(hex: key))
            let _realm = try! Realm(configuration: config)
            self.vault = Vault(withRealm: _realm)
            self.setLabels(key: key, fileUrl: config.fileURL?.path)
            self.ui_tableView.reloadData()
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vault?.countCards() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = ui_tableView.dequeueReusableCell(withIdentifier: "cell")
        if (cell == nil) {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        let card = vault?.getCard(atIndex: indexPath.row)
        cell?.textLabel?.text = card?.name
        cell?.detailTextLabel?.text = card?.identifier
        return cell!
    }
    
}

