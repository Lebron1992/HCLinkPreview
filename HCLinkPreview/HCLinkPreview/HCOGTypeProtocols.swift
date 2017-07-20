//
//  HCOGTypeProtocols.swift
//  HCLinkPreview
//
//  Created by Lebron on 20/07/2017.
//  Copyright © 2017 hacknocraft. All rights reserved.
//

// MARK: -

/// Basic metadata that is common to every type that can be represented in OpenGraph form
public protocol OGMetadata {
    init(values: [String: String])

    /// The title of your object as it should appear within the graph, e.g., "The Rock". Required in OpenGraph spec but treated as an optional value.
    var title: String? { get }

    /// An image URL which should represent your object within the graph. This has been renamed from `image` in the OpenGraph spec to better fit Cocoa idioms. Required in OpenGraph spec but treated as an optional value.
    var imageUrl: String? { get }

    /// The canonical URL of your object that will be used as its permanent ID in the graph, e.g., "http://www.imdb.com/title/tt0117500/". Required in OpenGraph spec but treated as an optional value.
    var url: String? { get }

    /// A URL to an audio file to accompany this object. This has been renamed from `audio` in the OpenGraph spec to better fit Cocoa idioms.
    var audioUrl: String? { get }

    /// A one to two sentence description of your object. This has been renamed from `description` in the OpenGraph spec to allow for objc compatibility.
    var graphDescription: String? { get }

    /// The word that appears before this object's title in a sentence. An enum of (a, an, the, "", auto). If auto is chosen, the consumer of your data should chose between "a" or "an". Default is "" (blank).
    var determiner: Determiner? { get }

    /// The locale these tags are marked up in. Of the format language_TERRITORY. Default is en_US. This has been renamed from `locale` in the OpenGraph spec to better fit Cocoa idioms.
    var localeString: String? { get }

    /// An array of other locales this page is available in. This has been renamed from `alternateLocales` in the OpenGraph spec to better fit Cocoa idioms.
    var alternateLocaleStrings: [String]? { get }

    /// If your object is part of a larger web site, the name which should be displayed for the overall site. e.g., "IMDb".
    var siteName: String? { get }

    /// A URL to a video file that complements this object. This has been renamed from `video` in the OpenGraph spec to better fit Cocoa idioms.
    var videoUrl: String? { get }
}

// MARK: -

/// Extended metadata that may exist for any kind of multimedia
public protocol OGMedia: OGMetadata {
    /// An alternate url to use if the webpage requires HTTPS.
    var secureUrl: String? { get }

    /// A MIME type for this image.
    var mimeType: String? { get }
}

/// Extended metadata that may exist for any kind of multimedia that is visually rendered (for example, an image or a movie).
public protocol OGVisualMedia: OGMedia {
    /// The number of pixels wide.
    var width: Double? { get }

    /// The number of pixels high.
    var height: Double? { get }
}

/// An empty protocol for images
public protocol OGImage: OGVisualMedia {}

// MARK: -

/// An empty protocol to serve as a base for any audio metadata
public protocol OGMusic: OGMedia {}

/// A song on an album or in a playlist
public protocol OGSong: OGMusic {
    /// >=1 - The song's length in seconds.
    var duration: Int? { get }

    /// The album this song is from. A song can belong to multiple albums.
    var albums: [OGAlbum]? { get }

    /// >=1 - Which disc of the album this song is on.
    var disc: Int? { get }

    /// >=1 - Which track this song is.
    var track: Int? { get }

    ///  The musician that made this song. Multiple artists can be involved in one song.
    var musicians: [OGProfile]? { get }
}

/// A song on an album or in a playlist
public protocol OGAlbum: OGMusic {
    ///  The song on this album.
    var song: OGSong? { get }

    ///  >=1 - The same as music:album:disc but in reverse.
    var disc: Int? { get }

    /// >=1 - The same as music:album:track but in reverse.
    var track: Int? { get }

    ///  The musician that made this song. This differs from the spec in being an array, rather than a single musician.
    var musicians: [OGProfile]? { get }

    /// The date the album was released.
    var releaseDate: DateTime? { get }
}

/// A collection of songs made by any number of people
public protocol OGPlaylist: OGMusic {
    ///  The songs on this album.
    var songs: [OGSong]? { get }

    ///  >=1 - The same as music:album:disc but in reverse.
    var disc: Int? { get }

    /// >=1 - The same as music:album:track but in reverse.
    var track: Int? { get }

    /// The creator of this playlist. This differs from the spec in being an array, rather than a single musician.
    var creators: [OGProfile]? { get }
}

/// A song being broadcasted by a dj is a radio station in OpenGraph terms
public protocol OGRadioStation: OGMusic {
    /// The creator of this playlist. This differs from the spec in being an array, rather than a single musician.
    var creators: [OGProfile]? { get }
}

// MARK: -

/// Extended metadata that may exist for any kind of video metadata (for example, an episode of a tv show, a movie, or a youtube clip)
public protocol OGVideo: OGVisualMedia {
    /// Actors in the movie.
    var actors: [OGProfile]? { get }

    /// The role they played.
    var roles: [String]? { get }

    /// Directors of the movie.
    var directors: [OGProfile]? { get }

    /// Writers of the movie.
    var writers: [OGProfile]? { get }

    /// >=1 - The movie's length in seconds.
    var duration: Int? { get }

    /// The date the movie was released.
    var releaseDate: DateTime? { get }

    /// Tag words associated with this movie.
    var tags: [String]? { get }
}

/// An empty protocol for movies that conforms to `OGVideo`
public protocol OGMovie: OGVideo {}

/// A multi-episode TV show. The metadata is identical to `OGMovie`.
public protocol OGTVShow: OGVideo {}

/// A video that doesn't belong in any other category. The metadata is identical to `OGMovie`.
public protocol OGOtherVideo: OGVideo {}

/// An empty protocol for an episode of a tv show
public protocol OGEpisode: OGVideo {
    /// Which series this episode belongs to.
    var series: OGTVShow? { get }
}

// MARK: -

/// A protocol that represents an essay, blog post, paper, or any other collection of words
public protocol OGArticle: OGMetadata {
    /// When the article was first published.
    var publishedTime: DateTime? { get }

    /// When the article was last changed.
    var modifiedTime: DateTime? { get }

    /// When the article is out of date after.
    var expirationTime: DateTime? { get }

    /// Writers of the article.
    var authors: [OGProfile]? { get }

    /// A high-level section name. E.g. Technology
    var section: String? { get }

    /// Tag words associated with this article.
    var tags: [String]? { get }
}

/// A protocol that represents a published or unpublished book
public protocol OGBook: OGMetadata {
    /// Who wrote this book.
    var authors: [OGProfile]? { get }

    /// The ISBN(-10 or -13) of a book
    var isbn: String? { get }

    /// The date the book was released.
    var releaseDate: DateTime? { get }

    /// Tag words associated with this book.
    var tags: [String]? { get }
}

/// A protocol that represents details about an individual
public protocol OGProfile: OGMetadata {
    /// A name normally given to an individual by a parent or self-chosen.
    var firstName: String? { get }

    /// A name inherited from a family or marriage and by which the individual is commonly known.
    var lastName: String? { get }

    /// A short unique string to identify them.
    var username: String? { get }

    /// Their gender. This differs from the spec in being a string that can contain any value, rather than a closed enum
    var gender: String? { get }
}
