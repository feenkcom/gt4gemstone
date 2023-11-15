Class {
	#name : #GtGemStoneMethodCodersModel,
	#superclass : #GtCodersModel,
	#instVars : [
		'session'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #converting }
GtGemStoneMethodCodersModel >> asCoderViewModel [
	^ GtGemStoneMethodCodersViewModel new coder: self
]

{ #category : #testing }
GtGemStoneMethodCodersModel >> isForClass [
	^ false
]

{ #category : #accessing }
GtGemStoneMethodCodersModel >> newCoderFor: aGsMethod [
	| coder |
	coder := GtGemStoneMethodCoderModel fromGsMethod: aGsMethod.
	coder coders: self.
	^ coder
]

{ #category : #accessing }
GtGemStoneMethodCodersModel >> object [
	^ nil
]

{ #category : #accessing }
GtGemStoneMethodCodersModel >> session [
	^ session
]

{ #category : #accessing }
GtGemStoneMethodCodersModel >> session: aGtSession [

	session := aGtSession
]
