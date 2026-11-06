Class {
	#name : #GtGemStoneGemDetails,
	#superclass : #GtGemStoneAbstractGemDetails,
	#instVars : [
		'gemStoneSessionId',
		'gemProcessId',
		'gemHost',
		'gemLogFileName',
		'stoneName',
		'gemStoneVersion',
		'failures'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance creation' }
GtGemStoneGemDetails class >> fromDictionary: aDictionary [

	^ self new setFromDictionary: aDictionary

]

{ #category : #accessing }
GtGemStoneGemDetails >> description [

	^ 'GemStone session ' , gemStoneSessionId asString ,
		', gem ' , gemProcessId asString ,
		' on ' , gemHost asString

]

{ #category : #accessing }
GtGemStoneGemDetails >> detailAttributes [
	| attributes |

	attributes := OrderedCollection new.
	attributes
		add: 'GemStone session' -> gemStoneSessionId;
		add: 'Gem pid' -> gemProcessId;
		add: 'Gem host' -> gemHost;
		add: 'Gem log' -> gemLogFileName;
		add: 'Stone' -> stoneName;
		add: 'GemStone version' -> gemStoneVersion.
	failures keysAndValuesDo: [ :aKey :aText |
		attributes add: ('Not available: ' , aKey) -> aText ].
	^ attributes

]

{ #category : #accessing }
GtGemStoneGemDetails >> failures [

	^ failures

]

{ #category : #accessing }
GtGemStoneGemDetails >> gemHost [

	^ gemHost

]

{ #category : #accessing }
GtGemStoneGemDetails >> gemLogFileName [

	^ gemLogFileName

]

{ #category : #private }
GtGemStoneGemDetails >> gemLogTailSize [

	^ 100000

]

{ #category : #accessing }
GtGemStoneGemDetails >> gemProcessId [

	^ gemProcessId

]

{ #category : #accessing }
GtGemStoneGemDetails >> gemStoneSessionId [

	^ gemStoneSessionId

]

{ #category : #accessing }
GtGemStoneGemDetails >> gemStoneVersion [

	^ gemStoneVersion

]

{ #category : #testing }
GtGemStoneGemDetails >> hasGemLog [

	^ gemLogFileName notNil

]

{ #category : #actions }
GtGemStoneGemDetails >> readGemLogUsing: aGtGemStoneSession [

	^ GtGemStoneGemLog
		fileName: gemLogFileName
		gemHost: gemHost
		values: (aGtGemStoneSession
			gemLogValuesFor: gemLogFileName
			keepingLast: self gemLogTailSize)
		session: aGtGemStoneSession

]

{ #category : #initialization }
GtGemStoneGemDetails >> setFromDictionary: aDictionary [

	gemStoneSessionId := aDictionary at: 'gemStoneSessionId' ifAbsent: [ nil ].
	gemProcessId := aDictionary at: 'gemProcessId' ifAbsent: [ nil ].
	gemHost := aDictionary at: 'gemHost' ifAbsent: [ nil ].
	gemLogFileName := aDictionary at: 'gemLogFileName' ifAbsent: [ nil ].
	stoneName := aDictionary at: 'stoneName' ifAbsent: [ nil ].
	gemStoneVersion := aDictionary at: 'gemStoneVersion' ifAbsent: [ nil ].
	failures := aDictionary at: 'failures' ifAbsent: [ Dictionary new ]

]

{ #category : #accessing }
GtGemStoneGemDetails >> stoneName [

	^ stoneName

]
