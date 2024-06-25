Class {
	#name : #GtpoGtRemotePhlowViewedObject,
	#superclass : #GtRsrProxyServiceClient,
	#instVars : [
		'viewSpecificationsBySelector'
	],
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject class >> remoteClassName [

	^ #GtRemotePhlowViewedObject
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> declarativeViews [
	^ viewSpecificationsBySelector 
		ifNil: [ super declarativeViews ] 
		ifNotNil: [ :aDictionary |
			aDictionary values ]
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getDeclarativeViewFor: aViewSelector [

	(viewSpecificationsBySelector notNil and: [
		viewSpecificationsBySelector includesKey: aViewSelector ])
			ifTrue: [ 
				^ (viewSpecificationsBySelector at: aViewSelector) phlowDataSource ].
	
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

{ #category : #testing }
GtpoGtRemotePhlowViewedObject >> hasCachedViewSpecifications [
	^ viewSpecificationsBySelector notNil
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> initializeFromProxyData: aDictionary [
	| declarativeViewDeclarations |
	declarativeViewDeclarations := aDictionary at: 'views' ifAbsent: [ #() ].
	
	viewSpecificationsBySelector := (declarativeViewDeclarations 
		collect: [ :declarativeViewData |
			| viewSpecification |
			viewSpecification := GtPhlowViewSpecification 
				fromDictionary: declarativeViewData.
			viewSpecification methodSelector -> viewSpecification ]) asDictionary
]
