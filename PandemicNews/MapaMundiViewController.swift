//
//  MapaMundiViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/28/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class MapaMundiViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var casosTotales: UILabel!
    @IBOutlet weak var paisesInfectados: UILabel!
    @IBOutlet weak var recuperadosTotales: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
  
    var datos = "World"
    
    
    
    private func cargaPais(){
      
        casosTotales.text = getCasosMundo(nombre: datos).value(forKey: "total_cases") as! String
        paisesInfectados.text = getPaisesTotales() as! String
        recuperadosTotales.text = getCasosMundo(nombre: datos).value(forKey: "total_recovered") as! String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! HomeViewController
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cargaPais()
        
        let myURL = URL(string: "https://www.trackcorona.live/map")
        let myRequest = URLRequest(url: myURL!)
        
        
        webView.load(myRequest)
        	

    }
    
    func getCasosMundo(nombre: String) -> NSManagedObject{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //array de paises ya guardados en la entidad CountrySelectedAlert
        var MundoGuardado: [NSManagedObject]
        //Peticion
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        var Pais: NSManagedObject!
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            MundoGuardado = results as! [NSManagedObject]
            //Si hay algun pais lo borra puesto que solo debe haber uno
            for paisG in MundoGuardado{
                if(nombre == paisG.value(forKey: "country") as! String){
                    Pais = paisG
                    
                }
            }
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        return Pais
    }
    
    
    

    func getPaisesTotales() -> String{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        //array de paises ya guardados en la entidad CountrySelectedAlert
        var paisesGuardados: [NSManagedObject]
        //Peticion
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Country")
        var Pais: NSManagedObject!
        var contador = 0
        
        do{
            let results = try managedContext.fetch(fetchRequest)
            paisesGuardados = results as! [NSManagedObject]
            //Si hay algun pais lo borra puesto que solo debe haber uno
            for paisG in paisesGuardados{
                if(paisG != nil){
                    contador += 1
                    
                }
            }
            try managedContext.save()
            
        }catch let error as NSError{
            print("No ha sido posible cargar \(error), \(error.userInfo)")
            
        }
        
        let numeroGuardadoInt = (contador as NSInteger).description
        return numeroGuardadoInt
    }
    
}
