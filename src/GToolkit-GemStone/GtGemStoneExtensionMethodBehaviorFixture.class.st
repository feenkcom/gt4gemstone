"
I am a minimal behavior-like fixture used to exercise GemStone extension protocol creation without requiring a GemStone session.
"
Class {
	#name : #GtGemStoneExtensionMethodBehaviorFixture,
	#superclass : #Object,
	#instVars : [
		'categories'
	],
	#category : #'GToolkit-GemStone-Examples'
}

{ #category : #accessing }
GtGemStoneExtensionMethodBehaviorFixture >> addCategory: aSymbol [
	categories add: aSymbol
]

{ #category : #accessing }
GtGemStoneExtensionMethodBehaviorFixture >> categories [
	^ categories
]

{ #category : #testing }
GtGemStoneExtensionMethodBehaviorFixture >> includesCategory: aSymbol [
	^ categories includes: aSymbol
]

{ #category : #initialization }
GtGemStoneExtensionMethodBehaviorFixture >> initialize [
	super initialize.
	categories := OrderedCollection new
]
