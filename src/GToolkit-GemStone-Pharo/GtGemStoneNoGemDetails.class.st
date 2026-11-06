Class {
	#name : #GtGemStoneNoGemDetails,
	#superclass : #GtGemStoneAbstractGemDetails,
	#instVars : [
		'reason'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance creation' }
GtGemStoneNoGemDetails class >> notRetrieved [

	^ self reason: 'Not retrieved'

]

{ #category : #'instance creation' }
GtGemStoneNoGemDetails class >> reason: aString [

	^ self new setReason: aString

]

{ #category : #accessing }
GtGemStoneNoGemDetails >> description [

	^ 'Gem details not available: ' , reason asString

]

{ #category : #accessing }
GtGemStoneNoGemDetails >> detailAttributes [

	^ OrderedCollection with: 'Gem details' -> self description

]

{ #category : #accessing }
GtGemStoneNoGemDetails >> gemHost [

	^ nil

]

{ #category : #accessing }
GtGemStoneNoGemDetails >> gemLogFileName [

	^ nil

]

{ #category : #accessing }
GtGemStoneNoGemDetails >> gemProcessId [

	^ nil

]

{ #category : #accessing }
GtGemStoneNoGemDetails >> gemStoneSessionId [

	^ nil

]

{ #category : #accessing }
GtGemStoneNoGemDetails >> gemStoneVersion [

	^ nil

]

{ #category : #testing }
GtGemStoneNoGemDetails >> hasGemLog [

	^ false

]

{ #category : #actions }
GtGemStoneNoGemDetails >> readGemLogUsing: aGtGemStoneSession [

	^ self error: self description

]

{ #category : #accessing }
GtGemStoneNoGemDetails >> reason [

	^ reason

]

{ #category : #initialization }
GtGemStoneNoGemDetails >> setReason: aString [

	reason := aString

]

{ #category : #accessing }
GtGemStoneNoGemDetails >> stoneName [

	^ nil

]
