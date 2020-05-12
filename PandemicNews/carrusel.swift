//
//  carrusel.swift
//  PandemicNews
//
//  Created by user152439 on 5/11/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import Foundation
import CoreData



extension UIImageView {
    func Downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func Downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}



class Carrusel: UICollectionViewCell
{
    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    public var paisesCarrusel = [NSManagedObject](){
        didSet {
            self.updateUI()
        }
    }
    
    func guardaPaisCarrusel(paisData: Pais){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity( forEntityName: "Country", in: managedContext)
        let pais = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        pais.setValue(paisData.country, forKey: "country")
        pais.setValue(paisData.flag, forKey: "flag")
        
        
        
        do{
            try managedContext.save()
            
            paisesCarrusel.append(pais)
        }catch let error as NSError{
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    
    func updateUI(){
            //imagenView.image = paisData.flag
            //label.text = carrusel.country
            
        }
    
    
        
    }
    
    

