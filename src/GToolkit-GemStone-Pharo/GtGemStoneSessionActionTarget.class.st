Class {
	#name : #GtGemStoneSessionActionTarget,
	#superclass : #GtPhlowActionTarget,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #accessing }
GtGemStoneSessionActionTarget class >> cleanUp [
	uniqueInstance := nil
]

{ #category : #accessing }
GtGemStoneSessionActionTarget class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]
