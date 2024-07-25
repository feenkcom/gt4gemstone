Class {
	#name : #GtpoGtRemotePhlowViewedObject,
	#superclass : #GtRsrProxyServiceClient,
	#instVars : [
		'viewSpecificationsBySelector',
		'actionSpecificationsBySelector'
	],
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject class >> remoteClassName [

	^ #GtRemotePhlowViewedObject
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> computeDeclarativeActionSpecificationsForCurrentObject [
	| specificationData specificationActionsData |
	specificationData := self getActionSpecifications.
	specificationActionsData := specificationData at: 'actions' ifAbsent: [ #() ].
	^ specificationActionsData 
		collect: [ :anActionSpecificationData |
			| actionSpecification |
			actionSpecification := GtPhlowActionSpecification 
				phlowActionFromDictionary: anActionSpecificationData.
			actionSpecification
				initializeFromInspector: self.
			actionSpecification ]
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> computeDeclarativeViewSpecificationsForCurrentObject [
	| specificationData specificationViewsData |
		
	specificationData := self getViewsDeclarations.
	specificationViewsData := specificationData at: 'views' ifAbsent: [ #() ].
	^ specificationViewsData collect: [ :aViewSpecificationData |
		| viewSpecification |
		viewSpecification := GtPhlowViewSpecification 
			fromDictionary: aViewSpecificationData.
		viewSpecification
			initializeFromInspector: self.
		viewSpecification ] 
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> declarativeActionsSpecificationsForCurrentObject [
	^ actionSpecificationsBySelector 
		ifNil: [ self computeDeclarativeActionSpecificationsForCurrentObject ] 
		ifNotNil: [ :aDictionary |
			aDictionary values ]
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> declarativeViewSpecificationsForCurrentObject [
	^ viewSpecificationsBySelector 
		ifNil: [ self computeDeclarativeViewSpecificationsForCurrentObject ] 
		ifNotNil: [ :aDictionary |
			aDictionary values ]
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getActionSpecifications [

	^ (self gtSession performEvaluation
		receiver: self;
		selector: #getActionSpecifications;
		returnLegacy) evaluateAndWait
]

{ #category : #accessing }
GtpoGtRemotePhlowViewedObject >> getDeclarativeActionDataSourceFor: anActionSelector [
	^ self
		proxyPerform: #getDeclarativeActionDataSourceFor: 
		withArguments: { anActionSelector asSymbol }
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
	| declarativeViewSpecifications declarativeActionsSpecifications |
	declarativeViewSpecifications := aDictionary at: 'views' ifAbsent: [ nil ].
	declarativeActionsSpecifications := aDictionary at: 'actions' ifAbsent: [ nil ].
	
	declarativeViewSpecifications ifNotNil: [
		viewSpecificationsBySelector := (declarativeViewSpecifications 
			collect: [ :viewSpecificationData |
				| viewSpecification |
				viewSpecification := GtPhlowViewSpecification 
					fromDictionary: viewSpecificationData.
				viewSpecification methodSelector -> viewSpecification ]) asDictionary ].
				
	declarativeActionsSpecifications ifNotNil: [
		actionSpecificationsBySelector := (declarativeActionsSpecifications 
			collect: [ :actionSpecificationData |
				| actionSpecification |
				actionSpecification := GtPhlowActionSpecification 
					phlowActionFromDictionary: actionSpecificationData.
				actionSpecification methodSelector -> actionSpecification ]) asDictionary ]
]
