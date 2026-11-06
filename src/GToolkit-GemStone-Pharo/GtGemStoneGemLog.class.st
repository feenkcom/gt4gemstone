Class {
	#name : #GtGemStoneGemLog,
	#superclass : #Object,
	#instVars : [
		'fileName',
		'gemHost',
		'readOnHost',
		'exists',
		'fileSize',
		'contents',
		'session'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance creation' }
GtGemStoneGemLog class >> fileName: aFileName gemHost: aHostName values: aDictionary session: aGtGemStoneSession [

	^ self new
		setFileName: aFileName
		gemHost: aHostName
		values: aDictionary
		session: aGtGemStoneSession

]

{ #category : #accessing }
GtGemStoneGemLog >> analysis [

	^ GtGemStoneGemLogAnalysis fromContents: contents

]

{ #category : #accessing }
GtGemStoneGemLog >> contents [

	^ contents

]

{ #category : #accessing }
GtGemStoneGemLog >> detailAttributes [
	| attributes |

	attributes := OrderedCollection new.
	attributes
		add: 'Gem log' -> fileName;
		add: 'Exists' -> exists;
		add: 'Gem host' -> gemHost;
		add: 'Read on host' -> readOnHost;
		add: 'File size' -> fileSize;
		add: 'Characters shown' -> contents size;
		add: 'Read with session' -> session.
	self isReadOnAnotherHost ifTrue: [
		attributes add: 'Warning' -> 'The gem ran on another host than the session that read the log' ].
	^ attributes

]

{ #category : #testing }
GtGemStoneGemLog >> exists [

	^ exists

]

{ #category : #accessing }
GtGemStoneGemLog >> fileName [

	^ fileName

]

{ #category : #ui }
GtGemStoneGemLog >> gtAnalysisFor: aView [
	<gtView>

	exists ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Analysis';
		priority: 5;
		items: [ self analysis attributes ];
		column: 'Attribute' text: [ :each | each key ] width: 150;
		column: 'Value' text:  [ :each | each value ];
		send: #value;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect the analysis'
			action: [ :aButton | aButton phlow spawnObject: self analysis ]

]

{ #category : #ui }
GtGemStoneGemLog >> gtDetailsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Details';
		priority: 20;
		items: [ self detailAttributes ];
		column: 'Attribute' text: #key;
		column: 'Value' text: #value;
		send: #value

]

{ #category : #ui }
GtGemStoneGemLog >> gtLogFor: aView [
	<gtView>

	^ aView textEditor
		title: 'Gem log';
		priority: 10;
		text: [ self logText asRopedText glamorousCodeFont ]

]

{ #category : #testing }
GtGemStoneGemLog >> isReadOnAnotherHost [

	^ gemHost notNil and: [ readOnHost ~= gemHost ]

]

{ #category : #testing }
GtGemStoneGemLog >> isTruncated [

	^ fileSize > contents size

]

{ #category : #accessing }
GtGemStoneGemLog >> logText [

	^ exists
		ifTrue: [ contents ]
		ifFalse: [ 'The gem log ' , fileName asString , ' does not exist on ' , readOnHost asString , '.' ]

]

{ #category : #printing }
GtGemStoneGemLog >> printOn: aStream [

	super printOn: aStream.
	aStream parenthesize: [ aStream nextPutAll: fileName asString ]

]

{ #category : #accessing }
GtGemStoneGemLog >> session [

	^ session

]

{ #category : #initialization }
GtGemStoneGemLog >> setFileName: aFileName gemHost: aHostName values: aDictionary session: aGtGemStoneSession [

	fileName := aFileName.
	gemHost := aHostName.
	session := aGtGemStoneSession.
	readOnHost := aDictionary at: 'readOnHost' ifAbsent: [ nil ].
	exists := aDictionary at: 'exists' ifAbsent: [ false ].
	fileSize := aDictionary at: 'size' ifAbsent: [ 0 ].
	contents := aDictionary at: 'contents' ifAbsent: [ '' ]

]
