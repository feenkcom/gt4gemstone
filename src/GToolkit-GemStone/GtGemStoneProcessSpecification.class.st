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
	
	^ aView columnedList 
		title: 'Frame specifications';
		priority: 50;
		items: [ self frameSpecifications ];
		actionUpdateButtonTooltip: 'Update item list';
		column: 'Index' 
			text: [ :eachItem :eachIndex | eachIndex  ]
			width: 45;
		column: 'ID' 
			text: [ :eachItem | eachItem frameIdentifier description  ]
			width: 45;
		column: 'Ip Offset' 
			text: [ :eachItem | eachItem ipOffset ]
			width: 45;
		column: 'Item' 
			text: [ :eachItem | eachItem gtDisplayText ]
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
