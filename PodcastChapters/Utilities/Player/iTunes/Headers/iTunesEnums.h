//
//  iTunesEnums.h
//  PodcastChapters
//
//  Created by Szabolcs Toth on 2016. 10. 10..
//  Copyright © 2016. Szabolcs Toth. All rights reserved.
//

enum iTunesEKnd {
    iTunesEKndTrackListing = 'kTrk' /* a basic listing of tracks within a playlist */,
    iTunesEKndAlbumListing = 'kAlb' /* a listing of a playlist grouped by album */,
    iTunesEKndCdInsert = 'kCDi' /* a printout of the playlist for jewel case inserts */
};
typedef enum iTunesEKnd iTunesEKnd;

enum iTunesEnum {
    iTunesEnumStandard = 'lwst' /* Standard PostScript error handling */,
    iTunesEnumDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum iTunesEnum iTunesEnum;

enum iTunesEPlS {
    iTunesEPlSStopped = 'kPSS',
    iTunesEPlSPlaying = 'kPSP',
    iTunesEPlSPaused = 'kPSp',
    iTunesEPlSFastForwarding = 'kPSF',
    iTunesEPlSRewinding = 'kPSR'
};
typedef enum iTunesEPlS iTunesEPlS;

enum iTunesERpt {
    iTunesERptOff = 'kRpO',
    iTunesERptOne = 'kRp1',
    iTunesERptAll = 'kAll'
};
typedef enum iTunesERpt iTunesERpt;

enum iTunesEShM {
    iTunesEShMSongs = 'kShS',
    iTunesEShMAlbums = 'kShA',
    iTunesEShMGroupings = 'kShG'
};
typedef enum iTunesEShM iTunesEShM;

enum iTunesEVSz {
    iTunesEVSzSmall = 'kVSS',
    iTunesEVSzMedium = 'kVSM',
    iTunesEVSzLarge = 'kVSL'
};
typedef enum iTunesEVSz iTunesEVSz;

enum iTunesESrc {
    iTunesESrcLibrary = 'kLib',
    iTunesESrcIPod = 'kPod',
    iTunesESrcAudioCD = 'kACD',
    iTunesESrcMP3CD = 'kMCD',
    iTunesESrcRadioTuner = 'kTun',
    iTunesESrcSharedLibrary = 'kShd',
    iTunesESrcITunesStore = 'kITS',
    iTunesESrcUnknown = 'kUnk'
};
typedef enum iTunesESrc iTunesESrc;

enum iTunesESrA {
    iTunesESrAAlbums = 'kSrL' /* albums only */,
    iTunesESrAAll = 'kAll' /* all text fields */,
    iTunesESrAArtists = 'kSrR' /* artists only */,
    iTunesESrAComposers = 'kSrC' /* composers only */,
    iTunesESrADisplayed = 'kSrV' /* visible text fields */,
    iTunesESrASongs = 'kSrS' /* song names only */
};
typedef enum iTunesESrA iTunesESrA;

enum iTunesESpK {
    iTunesESpKNone = 'kNon',
    iTunesESpKBooks = 'kSpA',
    iTunesESpKFolder = 'kSpF',
    iTunesESpKGenius = 'kSpG',
    iTunesESpKITunesU = 'kSpU',
    iTunesESpKLibrary = 'kSpL',
    iTunesESpKMovies = 'kSpI',
    iTunesESpKMusic = 'kSpZ',
    iTunesESpKPodcasts = 'kSpP',
    iTunesESpKPurchasedMusic = 'kSpM',
    iTunesESpKTVShows = 'kSpT'
};
typedef enum iTunesESpK iTunesESpK;

enum iTunesEMdK {
    iTunesEMdKAlertTone = 'kMdL' /* alert tone track */,
    iTunesEMdKAudiobook = 'kMdA' /* audiobook track */,
    iTunesEMdKBook = 'kMdB' /* book track */,
    iTunesEMdKHomeVideo = 'kVdH' /* home video track */,
    iTunesEMdKITunesU = 'kMdI' /* iTunes U track */,
    iTunesEMdKMovie = 'kVdM' /* movie track */,
    iTunesEMdKSong = 'kMdS' /* music track */,
    iTunesEMdKMusicVideo = 'kVdV' /* music video track */,
    iTunesEMdKPodcast = 'kMdP' /* podcast track */,
    iTunesEMdKRingtone = 'kMdR' /* ringtone track */,
    iTunesEMdKTVShow = 'kVdT' /* TV show track */,
    iTunesEMdKVoiceMemo = 'kMdO' /* voice memo track */,
    iTunesEMdKUnknown = 'kUnk'
};
typedef enum iTunesEMdK iTunesEMdK;

enum iTunesEVdK {
    iTunesEVdKNone = 'kNon' /* not a video or unknown video kind */,
    iTunesEVdKHomeVideo = 'kVdH' /* home video track */,
    iTunesEVdKMovie = 'kVdM' /* movie track */,
    iTunesEVdKMusicVideo = 'kVdV' /* music video track */,
    iTunesEVdKTVShow = 'kVdT' /* TV show track */
};
typedef enum iTunesEVdK iTunesEVdK;

enum iTunesERtK {
    iTunesERtKUser = 'kRtU' /* user-specified rating */,
    iTunesERtKComputed = 'kRtC' /* iTunes-computed rating */
};
typedef enum iTunesERtK iTunesERtK;

enum iTunesEAPD {
    iTunesEAPDComputer = 'kAPC',
    iTunesEAPDAirPortExpress = 'kAPX',
    iTunesEAPDAppleTV = 'kAPT',
    iTunesEAPDAirPlayDevice = 'kAPO',
    iTunesEAPDUnknown = 'kAPU'
};
typedef enum iTunesEAPD iTunesEAPD;

enum iTunesEClS {
    iTunesEClSUnknown = 'kUnk',
    iTunesEClSPurchased = 'kPur',
    iTunesEClSMatched = 'kMat',
    iTunesEClSUploaded = 'kUpl',
    iTunesEClSIneligible = 'kRej',
    iTunesEClSRemoved = 'kRem',
    iTunesEClSError = 'kErr',
    iTunesEClSDuplicate = 'kDup',
    iTunesEClSSubscription = 'kSub',
    iTunesEClSNoLongerAvailable = 'kRev',
    iTunesEClSNotUploaded = 'kUpP'
};
typedef enum iTunesEClS iTunesEClS;
