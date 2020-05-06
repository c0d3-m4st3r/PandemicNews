//
//  HomeViewController.swift
//  PandemicNews
//
//  Created by user152439 on 4/24/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit
import Foundation


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
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
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    //Array de paises
    public var paises = [Pais]()
    public var paisesFinal = [Pais]()
    
    @IBOutlet weak var barraNavegacion: UINavigationItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        barraNavegacion.title = "Lista de paises"
        
        let urlString = "https://corona-virus-stats.herokuapp.com/api/v1/cases/countries-search?limit=200"
        if let url = URL(string: urlString)
        {
            let task = URLSession.shared.dataTask(with: url) { data,response,error in
                print(response!)
                
        
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
                                                
                                                var country = Pais(nombre: "", bandera: "", numeroInfectados: 0, casosPorMillPersonas: "", recuperados: "", fallecidos: "")
                                                var guardaNum = ""
                                                for (llave, valor) in pais {
                                                    
                                                    if llave == "country" {
                                                        country.country = valor as! String
                                                        
                                                    }
                                                    if llave == "total_cases" {
                                                        guardaNum = valor as! String
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
                                                guardaNum = guardaNum.replacingOccurrences(of: ",", with: "")
                                                country.total_cases = (guardaNum as NSString).integerValue
                                                
                                                self.paises.append(country)
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
                
                
                self.paises.sort{
                    ($0.total_cases) > ($1.total_cases)
                }
                
                DispatchQueue.main.async{
                    self.collectionView.reloadData()
                }
            }
            task.resume()
        }
        
        
        
        
        
        /*for country in paises{
            print("-----------------------")
            print(country.country)
            print(country.flag)
            print(country.total_cases)
            print(country.total_deaths)
            print(country.cases_per_mill_pop)
            print(country.total_recovered)
        }
 */
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let item = sender as? UICollectionViewCell
        let indexPath = collectionView.indexPath(for: item!)
        let detailVC = segue.destination as! PaisIndividualViewController
        
        detailVC.index = indexPath!
        detailVC.paisIndividual = paises[(indexPath?.row)!]
        
    }
    
    func eliminarPais(item: IndexPath){
        //paises.remove(at: item.row)
        collectionView?.deleteItems(at: [item])
        collectionView?.reloadItems(at: [item])
    }
        
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return paises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let identifier = "pais"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PaisCollectionViewCell
        
        paisesFinal.append(paises[indexPath.row])
        cell.nombrePais.text = paises[indexPath.row].country
        cell.numeroInfectados.text = paises[indexPath.row].total_cases.description
        cell.banderaPais.contentMode = .scaleAspectFill
        cell.banderaPais.downloaded(from: paises[indexPath.row].flag)
        cell.nombrePais.textAlignment = .center
        cell.numeroInfectados.textAlignment = .center
        
        
        
        return cell
        
    }
    

}

