Class {
	#name : #GtGemStoneCodeSyncExplicitClassStrategy,
	#superclass : #GtGemStoneCodeSyncClassStrategy,
	#instVars : [
		'classes'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #accessing }
GtGemStoneCodeSyncExplicitClassStrategy >> classes [
	<return: #Collection of: #Symbol>

	^ classes
]

{ #category : #accessing }
GtGemStoneCodeSyncExplicitClassStrategy >> classes: aCollectionOfClassNames [

	classes := aCollectionOfClassNames
]

{ #category : #testing }
GtGemStoneCodeSyncExplicitClassStrategy >> syncClass: aClass registry: aGtGemStoneSessionRegistry [
	"Answer a boolean indicating whether the supplied class should be synced"

	^ classes includes: aClass instanceSide name
]
