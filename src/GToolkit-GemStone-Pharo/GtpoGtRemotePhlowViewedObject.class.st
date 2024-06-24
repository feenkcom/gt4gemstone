Class {
	#name : #GtpoGtRemotePhlowViewedObject,
	#superclass : #GtRsrProxyServiceClient,
	#instVars : [
		'declarativeViewsBySelector'
	],
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject class >> remoteClassName [

	^ #GtRemotePhlowViewedObject
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> declarativeViews [
	^ declarativeViewsBySelector 
		ifNil: [ super declarativeViews ] 
		ifNotNil: [ :aDictionary |
			aDictionary values ]
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getDeclarativeViewFor: aViewSelector [

	(declarativeViewsBySelector notNil and: [
		declarativeViewsBySelector includesKey: aViewSelector ])
			ifTrue: [ 
				^ (declarativeViewsBySelector at: aViewSelector) phlowDataSource ].
	
	^ (self gtSession performEvaluation
		receiver: self;
		selector: #getDeclarativeViewFor:;
		arguments: { aViewSelector asSymbol };
		returnLegacy) evaluateAndWait
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getDeclarativeViewMethodNames [
	^ (self proxyPerform: #getDeclarativeViewMethodNames autoCommit: false) object
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getViewDeclaration: aViewSelector [ 
	^ self
		proxyPerform: #getViewDeclaration:
		withArguments: { aViewSelector asSymbol }
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getViewsDeclarations [

	^ (self gtSession performEvaluation
		receiver: self;
		selector: #getViewsDeclarations;
		returnLegacy) evaluateAndWait
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> initializeFromProxyData: aDictionary [
	| declarativeViewDeclarations |
	declarativeViewDeclarations := aDictionary at: 'views' ifAbsent: [ #() ].
	
	declarativeViewsBySelector := (declarativeViewDeclarations 
		collect: [ :declarativeViewData |
			| viewSpecification |
			viewSpecification := GtPhlowViewSpecification 
				fromDictionary: declarativeViewData.
			viewSpecification methodSelector -> viewSpecification ]) asDictionary
]
