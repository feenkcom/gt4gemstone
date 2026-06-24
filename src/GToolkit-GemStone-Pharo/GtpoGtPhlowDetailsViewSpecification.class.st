Class {
	#name : #GtpoGtPhlowDetailsViewSpecification,
	#superclass : #GtpoGtPhlowViewSpecification,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #serialization }
GtpoGtPhlowDetailsViewSpecification class >> remoteClassName [ 
	^ #GtPhlowDetailsViewSpecification
]

{ #category : #'as yet unclassified' }
GtpoGtPhlowDetailsViewSpecification >> retrieveRowNodeData [
	^ self proxyPerform: #retrieveRowNodeData
]

{ #category : #'as yet unclassified' }
GtpoGtPhlowDetailsViewSpecification >> retrieveRowNodeRawValueAtRowIndex: aRowIndex [
	^ (self 
			proxyPerformReturnProxy: #retrieveRowNodeRawValueAtRowIndex: 
			withArguments: {aRowIndex}) asGtBareProxyObject
]

{ #category : #'as yet unclassified' }
GtpoGtPhlowDetailsViewSpecification >> retrieveRowNodes [
	^ self retrieveRowNodeData collect: [ :each |
			GtRemotePhlowDetailsNode fromJSONDictionary: each  ]
]
