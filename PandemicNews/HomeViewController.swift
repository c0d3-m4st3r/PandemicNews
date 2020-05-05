//
//  HomeViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/24/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import Foundation

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    //Array de paises
    var paises = [Pais]()
    
    @IBOutlet weak var barraNavegacion: UINavigationItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barraNavegacion.title = "Lista de paises"
        
        paises = cargaPaises()
        for country in paises {
            print("-----------------------")
            print(country.country)
            print(country.flag)
            print(country.total_cases)
            print(country.total_deaths)
            print(country.cases_per_mill_pop)
            print(country.total_recovered)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let item = sender as? UICollectionViewCell
        let indexPath = collectionView.indexPath(for: item!)
        let detailVC = segue.destination as! PaisIndividualViewController
        detailVC.paisIndividual = paises[(indexPath?.row)!]
    }
    
    private func cargaPaises() -> [Pais]{
        
        var Paises = [Pais]()
        
        let urlString = "https://corona-virus-stats.herokuapp.com/api/v1/cases/countries-search?limit=200"
        if let url = URL(string: urlString)
        {
            let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) -> Void  in
                print(response!)
                
                /*https://stackoverflow.com/questions/48016242/swift-urlsession-completion-handlers */
                if error != nil{
                    print(error!)
                    return
                }
                
                guard let mime = response?.mimeType, mime == "application/json" else {
                    print("Wrong Mine type!")
                    return
                    
                }
                do{
                   
                    if let json  = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        if let vector = json["data"] as? [String: Any]{
                            for (key, value) in vector {
                                if key == "rows"{
                                    if let datos = value as? [Any] {
                                        for dato in datos {
                                            if let pais = dato as? [String: Any] {
                                                
                                                var country = Pais(nombre: "", bandera: "", numeroInfectados: "", casosPorMillPersonas: "", recuperados: "", fallecidos: "")
                                                
                                                for (llave, valor) in pais {
                                                    
                                                    if llave == "country" {
                                                        country.country = valor as! String
                                                        
                                                    }
                                                    if llave == "total_cases" {
                                                        country.total_cases = valor as! String
                                                    }
                                                    if llave == "total_deaths" {
                                                        country.total_deaths = valor as! String
                                                    }
                                                    if llave == "total_recovered" {
                                                        country.total_recovered = valor as! String
                                                    }
                                                    if llave == "cases_per_mill_pop" {
                                                        country.cases_per_mill_pop = valor as! String
                                                    }
                                                    if llave == "flag" {
                                                        country.flag = valor as! String
                                                    }
                                                    
                                                }
                                                Paises.append(country)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                       
                    }
                   
                    
                } catch {
                    
                    print("Error during JSON serialization: \(error.localizedDescription)")
                }
               
            }).resume()
            for country in Paises {
                print("-----------------------")
                print(country.country)
                print(country.flag)
                print(country.total_cases)
                print(country.total_deaths)
                print(country.cases_per_mill_pop)
                print(country.total_recovered)
            }
           
            print("terminao")
        }
        for country in Paises {
            print("-----------------------")
            print(country.country)
            print(country.flag)
            print(country.total_cases)
            print(country.total_deaths)
            print(country.cases_per_mill_pop)
            print(country.total_recovered)
        }
        return Paises
        
        
        
        
        
        //Cargamos las fotos de los paises
  /*      let fotoEsp = UIImage(named: "Espana")
        let fotoReinoUnido = UIImage(named: "ReinoUnido")
        let fotoEeuu = UIImage(named: "EstadosUnidos")
        let fotoAlemania = UIImage(named: "Alemania")
        let fotoItalia = UIImage(named: "Italia")
        let fotoChina = UIImage(named: "China")
        //Creamos los paises
        let espana = Pais(nombre: "España", bandera: fotoEsp, numeroInfectados: 219764, casosPorMillPersonas: 4657, recuperados: 92355, fallecidos: 22524)
        let reinoUnido = Pais(nombre: "Reino Unido", bandera: fotoReinoUnido, numeroInfectados: 143464, casosPorMillPersonas: 2140.3, recuperados: 1918, fallecidos: 19506)
        let italia = Pais(nombre: "Italia", bandera: fotoItalia, numeroInfectados: 192994, casosPorMillPersonas: 3211.7, recuperados: 60498, fallecidos: 25969)
        let eeuu = Pais(nombre: "Estados Unidos", bandera: fotoEeuu, numeroInfectados: 889999, casosPorMillPersonas: 2691.7, recuperados: 85922, fallecidos: 50363)
        let alemania = Pais(nombre: "Alemania", bandera: fotoAlemania, numeroInfectados: 153129, casosPorMillPersonas: 1839.6, recuperados: 103300, fallecidos: 5575)
        let china = Pais(nombre: "China", bandera: fotoChina, numeroInfectados: 82804, casosPorMillPersonas: 58.9, recuperados: 77257, fallecidos: 4632)
        
        //Añadimos los paises al vector de paises
        paises = [espana, reinoUnido, italia, eeuu, alemania, china]
        paises.sort{
            ($0.numeroInfectados) > ($1.numeroInfectados)
        }
 */
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "pais"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PaisCollectionViewCell
        cell.nombrePais.text = paises[indexPath.row].country
        cell.numeroInfectados.text = paises[indexPath.row].total_cases.description
        //cell.banderaPais.image = paises[indexPath.row].flag
        
        cell.nombrePais.textAlignment = .center
        cell.numeroInfectados.textAlignment = .center
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
