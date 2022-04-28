Class {
	#name : 'GtGemStoneRPackage',
	#superclass : 'RPackage',
	#instVars : [
		'gemstoneClient',
		'gemstonePackageProxy'
	],
	#category : 'Gtoolkit-RemoteCoder-GemStone'
}

{ #category : 'instance creation' }
GtGemStoneRPackage class >> named: aSymbol gemstoneClient: aGtGemStoneClient [ 

	^ self new
		name: aSymbol;
		gemstoneClient: aGtGemStoneClient;
		getProxy
]

{ #category : 'accessing' }
GtGemStoneRPackage >> gemstoneClient [
	^ gemstoneClient
]

{ #category : 'accessing' }
GtGemStoneRPackage >> gemstoneClient: anObject [
	gemstoneClient := anObject
]

{ #category : 'private' }
GtGemStoneRPackage >> getProxy [
	"Get the GemStone proxy object for the receiver's package"

	gemstonePackageProxy := gemstoneClient evaluateAndWait: 
		'GtGemStoneRPackage named: ', name printString.
]

{ #category : 'as yet unclassified' }
GtGemStoneRPackage >> gtBaselinesFor: aView [

	^ aView empty
]

{ #category : 'as yet unclassified' }
GtGemStoneRPackage >> gtDefinedTagsFor: aView context: aPhlowContext [

	^ aView empty
]

{ #category : 'as yet unclassified' }
GtGemStoneRPackage >> gtDependencyAnalyzerFor: aView [

	^ aView empty
]

{ #category : 'as yet unclassified' }
GtGemStoneRPackage >> gtExamplesFor: aView [

	^ aView empty
]
