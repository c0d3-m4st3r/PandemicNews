//
//  Pais.swift
//  PandemicNews
//
//  Created by user152439 on 4/24/20.
//  Copyright © 2020 FJPAFRV2020. All rights reserved.
//

import UIKit

class Pais {
    
    //Aributos de Pais
    var country: String
    var flag: String
    var total_cases: String
    var cases_per_mill_pop: String
    var total_recovered: String
    var total_deaths: String
    
    init(nombre: String, bandera: String, numeroInfectados: String, casosPorMillPersonas: String, recuperados: String, fallecidos: String){
        
        
        //Dando valor a atributos
        self.country = nombre
        self.flag = bandera
        self.total_cases = numeroInfectados
        self.cases_per_mill_pop = casosPorMillPersonas
        self.total_recovered = recuperados
        self.total_deaths = fallecidos
    }
    
    
    
    
}
