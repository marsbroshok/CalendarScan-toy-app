//
//  TextParser.swift
//  CalendarScan
//
//  Created by Alexander on 26/05/15.
//  Copyright (c) 2015 marsbroshok. All rights reserved.
//

import Foundation


class TextParser {
    let desc = "Parse string of text to find entities like person, organization and address"
    let ner: NER
    
    init () {
        let modelPathNER = NSBundle.mainBundle().pathForResource("ner_model", ofType: "dat")
        self.ner = NER(NERmodel: modelPathNER)
    }
    
    
// Native iOS NER: NSLinguisticTagger
    
    func iOSfindNamedEntitiesForText(text: String) -> [String:[String]] {
        var dictOfEntities = [String:[String]]()
        let schemes = NSLinguisticTagger.availableTagSchemesForLanguage("en")
        let scheme = NSLinguisticTagSchemeNameType
        let options: NSLinguisticTaggerOptions  = [.OmitWhitespace, .OmitPunctuation, .JoinNames]
        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
        tagger.string = text
        tagger.enumerateTagsInRange(NSMakeRange(0, (text as NSString).length), scheme: scheme, options: options) {
            (tag, tokenRange, sentenceRange, _) in
            let token = (text as NSString).substringWithRange(tokenRange)
            if var tokensForTag =  dictOfEntities[tag] {
                tokensForTag.append(token)
                dictOfEntities[tag] = tokensForTag
            } else {
                dictOfEntities[tag] = [token]
            }
            
            print("\(token): \(tag)")
        }
        return dictOfEntities
    }
    
    
// Open-source MITIE NER
    
    func findNamedEntitesForText(text: String) -> [String:[String]] {
        var dictOfEntities = [String:[String]]()
        dictOfEntities = findAddressesForText(text)
        if let entities = self.ner.findNamedEntitiesForString(text) {
            if let arrayOfDicts = entities as? Array<Dictionary<String,AnyObject>> {
                if arrayOfDicts.count>0 {
                    for dict in arrayOfDicts {
                        let tag = dict["Tag"] as! String
                        let score = dict["Score"] as! Float
                        
                            let token = dict["Token"]as! String
                            if var tokensForTag =  dictOfEntities[tag] {
                                tokensForTag.append(token)
                                dictOfEntities[tag] = tokensForTag
                            } else {
                                dictOfEntities[tag] = [token]
                            }
                        
                    }
                }
            }
        }
        return dictOfEntities
    }
    
    func findAddressesForText(text: String) -> [String:[String]] {
        var dictOfEntities = [String:[String]]()
        if let entities = self.ner.findNamedEntitiesForString(text) {
            if let arrayOfDicts = entities as? Array<Dictionary<String,AnyObject>> {
                if arrayOfDicts.count>1 {
                    for i in 0...(arrayOfDicts.count-2) {
                        let dict = arrayOfDicts[i]
                        let tag = dict["Tag"] as! String
                        if let next_tag = arrayOfDicts[i+1]["Tag"] as? String {
                            let token = dict["Token"]as! String
                            let next_token = arrayOfDicts[i+1]["Token"] as! String
                            let score = dict["Score"] as! Float
                            if (tag == "BUILDN") && (next_tag == "STREET") {
                                if var tokensForTag =  dictOfEntities["ADDRESS"] {
                                    tokensForTag.append(token+" "+next_token)
                                    dictOfEntities["ADDRESS"] = tokensForTag
                                } else {
                                    dictOfEntities["ADDRESS"] = [token+" "+next_token]
                                }
                            }
                        }
                    }
                } else {
                    let i = 0
                    let dict = arrayOfDicts[i]
                    let tag = dict["Tag"] as! String
                    let token = dict["Token"]as! String
                    let score = dict["Score"] as! Float
                    if (tag == "STREET") { dictOfEntities["ADDRESS"] = [token] }
                }
            }
        }
        return dictOfEntities
    }


}