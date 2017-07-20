//
//  HCOGDataFetcher.swift
//  HCLinkPreview
//
//  Created by Lebron on 21/07/2017.
//  Copyright © 2017 hacknocraft. All rights reserved.
//

import Foundation
import Kanna

public class HCOGDataFetcher {

    private static let kMetaTagKey = "meta"
    private static let kPropertyKey = "property"
    private static let kContentKey = "content"
    private static let kPropertyPrefix = "og:"

    /// Fetch data from a URL and attempt to parse OpenGraph tags out of it
    ///
    /// - Parameters:
    ///   - urlString: The url string you want to fetch from
    ///   - completion: A block to call when a data task finishes downloading and parsing data. The first parameter is a boolean that indicates if parsing succeeded or failed, and the second is a OpenGraph metadata type from a website
    public static func fetchOData(urlString: String, completion: @escaping ((_ success: Bool, _ metaData: OGMetadata?) -> Void)) {

        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, _, _) in

            guard let data = data,
                let html = Kanna.HTML(html: data, encoding: .utf8),
                let header = html.head else {
                    completion(false, nil)
                    return
            }

            let metaTags = header.xpath(kMetaTagKey)
            var metadatum = [String: String]()

            for metaTag in metaTags {
                guard let property = metaTag[kPropertyKey],
                    let content = metaTag[kContentKey],
                    property.hasPrefix(kPropertyPrefix) else {
                        continue
                }
                metadatum[property] = content
            }

            guard let graph = Metadata.from(metadatum) else { return }

            completion(true, graph)

            }.resume()
    }

}
