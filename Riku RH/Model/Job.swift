//
//  Job.swift
//  Riku RH
//
//  Created by user on 29/03/2019.
//  Copyright © 2019 Esprit. All rights reserved.
//

import Foundation

class Job {
    var logoOffre:String
    var titreOffre:String
    var nomEntrepriseOffre:String
    var dateOffre:String
    var descripOffre:String
    var locationOffre:String
    var typeOffre:String
    var langageOffre:String
    var salaireOffre:String
    var experienceOffre:String
    var technologiesOffre:String
    
    init(logoOffre : String,
         titreOffre : String,
         nomEntrepriseOffre : String,
         dateOffre : String,
         descripOffre : String,
         locationOffre : String,
         typeOffre : String,
         langageOffre : String,
         salaireOffre : String,
         experienceOffre : String,
         technologiesOffre : String)
    {
        self.logoOffre = logoOffre
        self.titreOffre = titreOffre
        self.nomEntrepriseOffre = nomEntrepriseOffre
        self.dateOffre = dateOffre
        self.locationOffre = locationOffre
        self.typeOffre = typeOffre
        self.descripOffre = descripOffre
        self.langageOffre = langageOffre
        self.salaireOffre = salaireOffre
        self.experienceOffre = experienceOffre
        self.technologiesOffre = technologiesOffre
    }
}

