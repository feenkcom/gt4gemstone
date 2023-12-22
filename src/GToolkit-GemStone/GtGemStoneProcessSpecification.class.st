Class {
	#name : #GtGemStoneProcessSpecification,
	#superclass : #GtGemStoneMethodsSpecification,
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance creation' }
GtGemStoneProcessSpecification class >> forGsCallStack: aCallStack [
	^ self new 
		initializeForGsCallStack: aCallStack
]

{ #category : #accessing }
GtGemStoneProcessSpecification >> frameSpecifications [
	^ self methodCoderSpecifications
]

{ #category : #'gt - extensions' }
GtGemStoneProcessSpecification >> gtViewCallFrameSpecificationsFor: aView [ 
	<gtView>
	
	^ aView forward 
		title: 'Frame specifications';
		object: [ self frameSpecifications];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtGemStoneProcessSpecification >> initializeForGsCallStack: aCallStack [
	methodCoderSpecifications := (aCallStack callFrames 
		collect: [ :aGsCallFrame |
			GtGemStoneContextSpecification forGsCallFrame: aGsCallFrame ]) asArray
]

{ #category : #accessing }
GtGemStoneProcessSpecification >> instantiateCoderSpecificationFromJsonData: aCoderJsonData [ 
	^ GtGemStoneContextSpecification  fromJSONDictionary: aCoderJsonData
]
