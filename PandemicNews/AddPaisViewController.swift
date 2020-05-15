//
//  AddPaisViewController.swift
//  PandemicNews
//
//  Created by user152439 on 5/8/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import CoreData
import Foundation


class AddPaisViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var botnAñadir: UIButton!
    @IBOutlet weak var deaths: UITextField?
    @IBOutlet weak var recovered: UITextField?
    @IBOutlet weak var country: UITextField?
    @IBOutlet weak var casesPerMil: UITextField?
    @IBOutlet weak var totalCases: UITextField?
    
    

    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deaths?.delegate = self
        recovered?.delegate = self
        country?.delegate = self
        casesPerMil?.delegate = self
        totalCases?.delegate = self
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
      
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func addFoto(_ sender: Any){
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func hola(_ sender: Any){
        
    }
    
    
    @IBAction func addPais(_ sender: Any){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity( forEntityName: "PersonalizedCountries", in: managedContext)
        let pais = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        pais.setValue(country?.text as! String, forKey: "country")
        pais.setValue(totalCases?.text as! String, forKey: "total_cases")
        pais.setValue(recovered?.text as! String, forKey: "total_recovered")
        pais.setValue(deaths?.text as! String, forKey: "total_deaths")
        pais.setValue(casesPerMil?.text as! String, forKey: "total_cases_per_mill_pop")
        var imagenCodificada = (flag.image)!.pngData()
        pais.setValue(imagenCodificada, forKey: "flagImage")
        
        
        
        
        do{
            try managedContext.save()
            
            
        }catch let error as NSError{
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
        
        self.navigationController?.popViewController(animated: true)
 
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        flag.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        flag.contentMode = .scaleAspectFill
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
}
