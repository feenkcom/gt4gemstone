Class {
	#name : #GtGemStoneCodeSyncSubclassClassStrategy,
	#superclass : #GtGemStoneCodeSyncClassStrategy,
	#instVars : [
		'superclass'
	],
	#category : #'GToolkit-GemStone-Pharo-CodeSync'
}

{ #category : #accessing }
GtGemStoneCodeSyncSubclassClassStrategy >> gtDisplayOn: aStream [

	aStream
		<< 'subclasses of: ';
		print: superclass
]

{ #category : #accessing }
GtGemStoneCodeSyncSubclassClassStrategy >> superclass [
	^ superclass
]

{ #category : #accessing }
GtGemStoneCodeSyncSubclassClassStrategy >> superclass: aClass [

	superclass := aClass instanceSide
]

{ #category : #testing }
GtGemStoneCodeSyncSubclassClassStrategy >> syncClass: aClass session: aGtGemStoneSession [
	"Answer a boolean indicating whether the supplied class should be synced"

	^ aClass instanceSide inheritedFrom: superclass
]
