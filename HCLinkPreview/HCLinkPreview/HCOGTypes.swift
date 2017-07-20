//
//  HCOGTypes.swift
//  HCLinkPreview
//
//  Created by Lebron on 20/07/2017.
//  Copyright © 2017 hacknocraft. All rights reserved.
//

public class Metadata: OGMetadata {

    public fileprivate(set) var title: String?
    public fileprivate(set) var imageUrl: String?
    public fileprivate(set) var url: String?

    public fileprivate(set) var audioUrl: String?
    public fileprivate(set) var graphDescription: String?
    public fileprivate(set) var determiner: Determiner?
    public fileprivate(set) var localeString: String?
    public fileprivate(set) var alternateLocaleStrings: [String]?
    public fileprivate(set) var siteName: String?
    public fileprivate(set) var videoUrl: String?

    public fileprivate(set) var rawData: [String: String]

    /// The designated initializer for OpenGraph metadata types. Direct usage of this is discouraged; `Metadata.from(_:)` will switch over any `og:type` and create the right class automatically
    ///
    /// - Parameter values: a dictionary of OpenGraph data
    public required init(values: [String: String]) {
        self.rawData = values

        self.title = values["og:title"]
        self.imageUrl = values["og:image"]
        self.url = values["og:url"]

        self.audioUrl = values["og:audio"]
        self.graphDescription = values["og:description"]

        if let determiner = values["og:determiner"] {
            self.determiner = Determiner(rawValue: determiner)
        }

        self.localeString = values["og:locale:alternate"]

        if let alternateLocale = values["og:locale:alternate"] {
            self.alternateLocaleStrings = [alternateLocale]
        }

        self.siteName = values["og:site_name"]
        self.videoUrl = values["og:video"]
    }

    /// A class function to create an `OpenGraph` class for any supported OpenGraph type of object
    ///
    /// - Parameter values: a dictionary of OpenGraph data
    /// - Returns: `nil` if `og:type` isn't specified in the `values` dictionary, otherwise an OpenGraph object type
    public class func from(_ values: [String: String]) -> Metadata? {
        guard let type = values["og:type"] else { return nil }

        switch type {
        case "music.song": return Song(values: values)
        case "music.album": return Album(values: values)
        case "music.playlist": return Playlist(values: values)
        case "music.radio_station": return RadioStation(values: values)
        case "video.movie": return Movie(values: values)
        case "video.episode": return Episode(values: values)
        case "video.tv_show": return TVShow(values: values)
        case "video.other": return OtherVideo(values: values)
        case "article": return Article(values: values)
        case "book": return Book(values: values)
        case "profile": return Profile(values: values)
        default: return Metadata(values: values)
        }
    }
}

extension Metadata: CustomStringConvertible {

    public var description: String {
        var mirrors = [Mirror]()
        var mirror: Mirror? = Mirror(reflecting: self)
        var description = "<\(Unmanaged.passUnretained(self).toOpaque())> \(mirror!.subjectType): {"

        while mirror != nil {
            mirrors.insert(mirror!, at: 0)
            mirror = mirror!.superclassMirror
        }

        for i in 0 ..< mirrors.count {
            let mirror = mirrors[i]
            let tabsForLevel = String(repeating: "\t", count: i + 1)

            description += mirror.children.flatMap {
                guard let key = $0.label else { return nil }
                return "\n \(tabsForLevel)\(key): \($0.value),"
                } .reduce("") { return $0 + $1 }

            description += "\n\(tabsForLevel)\(mirror.subjectType): {"
        }

        for i in stride(from: mirrors.count, to: 0, by: -1) {
            description += "\n\(String(repeating: "\t", count: i))}"
        }

        return description + "\n}"
    }
}

// MARK: -

public class Media: Metadata, OGMedia {
    public fileprivate(set) var secureUrl: String?
    public fileprivate(set) var mimeType: String?
}

public class VisualMedia: Media, OGVisualMedia {
    public fileprivate(set) var width: Double?
    public fileprivate(set) var height: Double?
}

// MARK: -

public final class Image: VisualMedia, OGImage {
    public required init(values: [String: String]) {
        super.init(values: values)

        self.url = values["og:image"]
        self.url = values["og:image:url"]

        self.secureUrl = values["og:image:secure_url"]
        self.mimeType = values["og:image:type"]

        if let width = values["og:image:width"] { self.width = Double(width) }
        if let height = values["og:image:height"] { self.height = Double(height) }
    }
}

// MARK: -

public class Music: Media, OGMusic {
    public required init(values: [String: String]) {
        super.init(values: values)

        self.url = values["og:audio"]
        self.url = values["og:audio:url"]
        self.secureUrl = values["og:audio:secure_url"]
        self.mimeType = values["og:audio:type"]
    }
}

public final class Song: Music, OGSong {

    public fileprivate(set) var duration: Int?
    public fileprivate(set) var albums: [OGAlbum]?
    public fileprivate(set) var disc: Int?
    public fileprivate(set) var track: Int?
    public fileprivate(set) var musicians: [OGProfile]?

    public required init(values: [String: String]) {
        super.init(values: values)

        if let duration = values["og:music:duration"] { self.duration = Int(duration) }

//        if let albums = values["og:music:album"] as? [[String: String]] { self.albums = albums.map { return Album(values: $0) } }

        if let disc = values["og:music:album:disc"] { self.disc = Int(disc) }
        if let track = values["og:music:track"] { self.track = Int(track) }

//        if let musicians = values["og:music:musician"] as? [[String: String]] {
//            self.musicians = musicians.map { return Profile(values: $0) }
//            
//        } else if let musician = values["og:music:musician"] as? [String: String] {
//            self.musicians = [ Profile(values: musician) ]
//        }
    }
}

public final class Album: Music, OGAlbum {
    public fileprivate(set) var song: OGSong?
    public fileprivate(set) var disc: Int?
    public fileprivate(set) var track: Int?
    public fileprivate(set) var musicians: [OGProfile]?
    public fileprivate(set) var releaseDate: DateTime?

    public required init(values: [String: String]) {
        super.init(values: values)

//        if let song = values["og:music:song"] as? [String: String] { self.song = Song(values: song) }
        if let disc = values["og:music:album:disc"] { self.disc = Int(disc) }
        if let track = values["og:music:track"] { self.track = Int(track) }

//        if let musicians = values["og:music:musician"] as? [[String: String]] {
//            self.musicians = musicians.map { return Profile(values: $0) }
//            
//        } else if let musician = values["og:music:musician"] as? [String: String] {
//            self.musicians = [ Profile(values: musician) ]
//        }

        if let releaseDate = values["og:music:release_date"] { self.releaseDate = DateTime(value: releaseDate) }
    }
}

public final class Playlist: Music, OGPlaylist {
    public fileprivate(set) var songs: [OGSong]?
    public fileprivate(set) var disc: Int?
    public fileprivate(set) var track: Int?
    public fileprivate(set) var creators: [OGProfile]?

    public required init(values: [String: String]) {
        super.init(values: values)

//        if let song = values["og:music:song"] as? [[String: String]] { self.songs = song.map { return Song(values: $0) } }
        if let disc = values["og:music:album:disc"] { self.disc = Int(disc) }
        if let track = values["og:music:track"] { self.track = Int(track) }

//        if let creator = values["og:music:creator"] as? [[String: String]] {
//            self.creators = creator.map { return Profile(values: $0) }
//            
//        } else if let creator = values["og:music:creator"] as? [String: String] {
//            self.creators = [ Profile(values: creator) ]
//        }
    }
}

public final class RadioStation: Music, OGRadioStation {
    public fileprivate(set) var creators: [OGProfile]?

    public required init(values: [String: String]) {
        super.init(values: values)

//        if let creator = values["og:music:creator"] as? [[String: String]] {
//            self.creators = creator.map { return Profile(values: $0) }
//            
//        } else if let creator = values["og:music:creator"] as? [String: String] {
//            self.creators = [ Profile(values: creator) ]
//        }
    }
}

// MARK: -

public class Video: VisualMedia {
    public fileprivate(set) var actors: [OGProfile]?
    public fileprivate(set) var roles: [String]?
    public fileprivate(set) var directors: [OGProfile]?
    public fileprivate(set) var writers: [OGProfile]?
    public fileprivate(set) var duration: Int?
    public fileprivate(set) var releaseDate: DateTime?
    public fileprivate(set) var tags: [String]?

    public required init(values: [String: String]) {
        super.init(values: values)

        self.url = values["og:video"]
        self.url = values["og:video:url"]
        self.secureUrl = values["og:video:secure_url"]
        self.mimeType = values["og:video:type"]

        if let width = values["og:video:width"] { self.width = Double(width) }
        if let height = values["og:video:height"] { self.height = Double(height) }

//        if let actors = values["og:video:actor"] as? [[String: String]] { self.actors = actors.map { return Profile(values: $0) } }

//        if let roles = values["og:video:actor:role"] as? [String] { self.roles = roles }
//        if let directors = values["og:video:director"] as? [[String: String]] { self.directors = directors.map { return Profile(values: $0) } }
//        if let writers = values["og:video:writer"] as? [[String: String]] { self.writers = writers.map { return Profile(values: $0) } }
        if let duration = values["og:video:duration"] { self.duration = Int(duration) }
        if let releaseDate = values["og:video:release_date"] { self.releaseDate = DateTime(value: releaseDate) }
//        if let tags = values["og:video:tag"] as? [String] { self.tags = tags }
    }
}

public final class Movie: Video, OGMovie {}
public final class TVShow: Video, OGTVShow {}
public final class OtherVideo: Video, OGOtherVideo {}

public final class Episode: Video, OGEpisode {
    public fileprivate(set) var series: OGTVShow?

    public required init(values: [String: String]) {
        super.init(values: values)

//        if let series = values["og:video:series"] as? [String: String] { self.series = TVShow(values: series) }
    }
}

// MARK: -

public final class Article: Metadata, OGArticle {

    public fileprivate(set) var publishedTime: DateTime?
    public fileprivate(set) var modifiedTime: DateTime?
    public fileprivate(set) var expirationTime: DateTime?
    public fileprivate(set) var authors: [OGProfile]?
    public fileprivate(set) var section: String?
    public fileprivate(set) var tags: [String]?

    public required init(values: [String: String]) {
        super.init(values: values)

        if let publishedTime = values["og:article:published_time"] { self.publishedTime = DateTime(value: publishedTime) }
        if let modifiedTime = values["og:article:modified_time"] { self.modifiedTime = DateTime(value: modifiedTime) }
        if let expirationTime = values["og:article:expiration_time"] { self.expirationTime = DateTime(value: expirationTime) }
//        if let authors = values["og:article:author"] as? [[String: String]] { self.authors = authors.map { return Profile(values: $0) } }
        self.section = values["og:article:section"]
//        if let tags = values["og:article:tag"] as? [String] { self.tags = tags }
    }
}

public final class Book: Metadata, OGBook {

    public fileprivate(set) var authors: [OGProfile]?
    public fileprivate(set) var isbn: String?
    public fileprivate(set) var releaseDate: DateTime?
    public fileprivate(set) var tags: [String]?

    public required init(values: [String: String]) {
        super.init(values: values)

//        if let authors = values["og:book:author"] as? [[String: String]] { self.authors = authors.map { return Profile(values: $0) } }
        self.isbn = values["og:book:isbn"]
        if let releaseDate = values["og:book:release_date"] { self.releaseDate = DateTime(value: releaseDate) }
//        if let tags = values["og:book:tag"] as? [String] { self.tags = tags }
    }
}

public final class Profile: Metadata, OGProfile {

    public fileprivate(set) var firstName: String?
    public fileprivate(set) var lastName: String?
    public fileprivate(set) var username: String?
    public fileprivate(set) var gender: String?

    public required init(values: [String: String]) {
        super.init(values: values)

        self.firstName = values["og:profile:first_name"]
        self.lastName = values["og:profile:last_name"]
        self.username = values["og:profile:username"]
        self.gender = values["og:profile:gender"]
    }
}

/// A DateTime represents a temporal value composed of a date (year, month, day) and an optional time component (hours, minutes)
public struct DateTime {

    fileprivate enum DateTimeProperty {
        case year
        case month
        case day
        case hours
        case minutes
    }

    var year: Int
    var month: Int
    var day: Int

    var hours: Int?
    var minutes: Int?

    /// Create a `DateTime` object for a given temporal value
    ///
    /// - Parameter value: An ISO8601-formatted string to be parsed into a date
    init(value: String) {
        var year: Int?
        var month: Int?
        var day: Int?

        var current = ""
        var property: DateTimeProperty = .year

        for i in 0..<current.utf8.count {

            var previousEnding: String?
            var length = 0

            switch property {
            case .year:
                previousEnding = ""
                length = 4
            case .month:
                previousEnding = "-"
                length = 2
            case .day:
                previousEnding = "-"
                length = 2
            case .hours:
                previousEnding = "T"
                length = 2
            case .minutes:
                previousEnding = ":"
                length = 2
            }

            guard let character = current.characterAt(index: i) else { break }

            if String(character) == previousEnding {
                continue
            }

            if current.utf8.count == length {
                switch property {
                case .year:
                    year = Int(current)
                    property = .month
                case .month:
                    month = Int(current)
                    property = .day
                case .day:
                    day = Int(current)
                    property = .hours
                case .hours:
                    hours = Int(current)
                    property = .minutes
                case .minutes:
                    minutes = Int(current)
                }
            } else {
                current.append(character)
            }
        }

        self.year = year ?? 0
        self.month = month ?? 0
        self.day = day ?? 0
    }
}

// MARK: -

/// The word that appears before this object's title in a sentence. An enum of (a, an, the, "", auto). If auto is chosen, the consumer of your data should chose between "a" or "an". Default is "" (blank).
public enum Determiner: RawRepresentable {

    public typealias RawValue = String

    case a
    case an
    case blank
    case the
    case quotes
    case auto

    public init?(rawValue: RawValue) {
        switch rawValue.lowercased() {
        case "a": self = .a
        case "an": self = .an
        case "": self = .blank
        case "the": self = .the
        case "\"": self = .quotes
        case "'": self = .quotes
        case "‘": self = .quotes
        case "’": self = .quotes
        case "“": self = .quotes
        case "”": self = .quotes
        case "auto": self = .auto
        default: return nil
        }
    }

    public var rawValue: RawValue {
        switch self {
        case .a: return "a"
        case .an: return "an"
        case .blank: return ""
        case .the: return "the"
        case .quotes: return "\""
        case .auto: return "auto"
        }
    }
}
