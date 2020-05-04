//
//  Pais.swift
//  PandemicNews
//
//  Created by user152439 on 4/24/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit

class Pais: Codable {
    
    //Aributos de Pais
    var country: String
    var flag: String
    var total_cases: Int
    var cases_per_mill_pop: Float
    var total_recovered: Int
    var total_deaths: Int
    
    init(nombre: String, bandera: String, numeroInfectados: Int, casosPorMillPersonas: Float, recuperados: Int, fallecidos: Int){
        
        
        //Dando valor a atributos
        self.country = nombre
        self.flag = bandera
        self.total_cases = numeroInfectados
        self.cases_per_mill_pop = casosPorMillPersonas
        self.total_recovered = recuperados
        self.total_deaths = fallecidos
    }
    
    
    
    
}
