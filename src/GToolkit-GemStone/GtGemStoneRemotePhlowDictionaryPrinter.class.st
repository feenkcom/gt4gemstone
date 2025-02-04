Class {
	#name : #GtGemStoneRemotePhlowDictionaryPrinter,
	#superclass : #GtGemStoneRemotePhlowCollectionPrinter,
	#category : #'GToolkit-GemStone'
}

{ #category : #enumerating }
GtGemStoneRemotePhlowDictionaryPrinter >> elementsDo: aBlock [
	targetCollection associationsDo: aBlock
]
