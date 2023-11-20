Class {
	#name : #GtGemStoneMethodCodersModel,
	#superclass : #GtCodersModel,
	#instVars : [
		'session'
	],
	#category : #'GToolkit-GemStone-Lepiter-Coder'
}

{ #category : #accessing }
GtGemStoneMethodCodersModel class >> forMethodSpecifications: aMethodCodersSpecification inSession: aSession [
	^ self new 
		initializeForMethodSpecifications: aMethodCodersSpecification 
		inSession: aSession
]

{ #category : #converting }
GtGemStoneMethodCodersModel >> asCoderViewModel [
	^ GtGemStoneMethodCodersViewModel new coder: self
]

{ #category : #accessing }
GtGemStoneMethodCodersModel >> initializeForMethodSpecifications: aMethodCodersSpecification inSession: aSession [
	self session: aSession.
	self forItems: aMethodCodersSpecification methodCoderSpecifications.
]

{ #category : #testing }
GtGemStoneMethodCodersModel >> isForClass [
	^ false
]

{ #category : #accessing }
GtGemStoneMethodCodersModel >> newCoderFor: aGsMethodSpecification [
	| coder |
	coder := GtGemStoneMethodCoderModel 
		fromCoderSpecification: aGsMethodSpecification 
		inSession: self session.
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
