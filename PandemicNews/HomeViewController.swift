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

    struct Response: Decodable{
        let paisesCol: [Paises]
    }
    
    struct Paises: Decodable{
        var country: String
        var country_abbreviation: String
        var total_cases: String
        var new_cases: String
        var total_deaths: String
        var new_deaths: String
        var total_recovered: String
        var active_cases: String
        var serious_critical: String
        var cases_per_mill_pop: String
        var flag: String
        
        init(country: String, country_abbreviation: String, total_cases: String, new_cases: String, total_deaths: String, new_deaths: String, total_recovered: String, active_cases: String, serious_critical: String, cases_per_mill_pop: String, flag: String) {
            self.country = country
            self.country_abbreviation = country_abbreviation
            self.total_cases = total_cases
            self.new_cases = new_cases
            self.total_deaths = total_deaths
            self.new_deaths = new_deaths
            self.total_recovered = total_recovered
            self.active_cases = active_cases
            self.serious_critical = serious_critical
            self.cases_per_mill_pop = cases_per_mill_pop
            self.flag = flag
        }
    }
    
    
    //Array de paises
    var paises = [Pais]()
    
    @IBOutlet weak var barraNavegacion: UINavigationItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        barraNavegacion.title = "Lista de paises"
        
        cargaPaises()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let item = sender as? UICollectionViewCell
        let indexPath = collectionView.indexPath(for: item!)
        let detailVC = segue.destination as! PaisIndividualViewController
        detailVC.paisIndividual = paises[(indexPath?.row)!]
    }
    
    private func cargaPaises(){
        
        let urlString = "https://corona-virus-stats.herokuapp.com/api/v1/cases/countries-search"
        if let url = URL(string: urlString)
        {
            let task = URLSession.shared.dataTask(with: url) { data, res, err in
                print(res!)
                
                if err != nil{
                    print(err!)
                    return
                }
                
                
                do{
                    if let json  = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]{
                        if let country = json["country"] as? [String]{
                            print(country)
                        }
                    }
                } catch let error as NSError{
                    print("Error during JSON serialization: \(error.localizedDescription)")
                }
                
            }
            task.resume()
            print("terminao")
        }
        
        
        
        
        
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
