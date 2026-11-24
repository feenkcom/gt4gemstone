"
I check #sameContentAs: in a live GemStone.
GemStone never answers a String and a Symbol as equal. Names sent by the other side of a connection can be either, so the remote Phlow code that also runs in GemStone compares them with #sameContentAs:, defined for GemStone in GToolkit-GemStone-GemStone.
My examples need a gt4gemstone newer than 1.1.699; with an older version they do nothing.
"
Class {
	#name : #GtRemoteGemStoneSameContentAsExamples,
	#superclass : #Object,
	#traits : 'TGtRemoteGemStoneSesionCreator',
	#classTraits : 'TGtRemoteGemStoneSesionCreator classTrait',
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #examples }
GtRemoteGemStoneSameContentAsExamples >> dictionariesWithTheSameKeysAndValues [
	"Dictionaries compare their keys and values by content, also nested in arrays,
	as the exported data of a remote Phlow specification"

	<gtExample>
	<after: #stopServer>
	| results |
	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_699
		do: [ ^ self ].

	results := self runningServer
			evaluateBlockAndWaitReturnPrimitive: [ | withSymbols withStrings other |
				withSymbols := Dictionary new.
				withSymbols
					at: '__typeName' put: #GtRemotePhlowListingViewSingleSelection;
					at: #selectionItems put: (Array with: (Dictionary new at: #nodeIndex put: 3; yourself)).
				withStrings := Dictionary new.
				withStrings
					at: '__typeName' put: 'GtRemotePhlowListingViewSingleSelection';
					at: 'selectionItems' put: (Array with: (Dictionary new at: 'nodeIndex' put: 3; yourself)).
				other := Dictionary new.
				other
					at: '__typeName' put: 'GtRemotePhlowListingViewMultipleSelection';
					at: 'selectionItems' put: (Array with: (Dictionary new at: 'nodeIndex' put: 3; yourself)).
				{withSymbols sameContentAs: withStrings.
					withStrings sameContentAs: withSymbols.
					withSymbols sameContentAs: other.
					withSymbols sameContentAs: (Array with: 3)} ].
	self assert: results asArray equals: #(true true false false).
	^ results
]

{ #category : #examples }
GtRemoteGemStoneSameContentAsExamples >> otherObjectsCompareWithEquality [
	"Objects that are not Strings, Symbols or collections compare with #="

	<gtExample>
	<after: #stopServer>
	| results |
	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_699
		do: [ ^ self ].

	results := self runningServer
			evaluateBlockAndWaitReturnPrimitive: [ {nil sameContentAs: nil.
					nil sameContentAs: 'abc'.
					42 sameContentAs: 42.
					42 sameContentAs: 43} ].
	self assert: results asArray equals: #(true false true false).
	^ results
]

{ #category : #examples }
GtRemoteGemStoneSameContentAsExamples >> sequencesWithTheSameElements [
	"Sequences of the same species compare their elements by content"

	<gtExample>
	<after: #stopServer>
	| results |
	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_699
		do: [ ^ self ].

	results := self runningServer
			evaluateBlockAndWaitReturnPrimitive: [ {(Array with: #icon with: 'text' with: 1)
						sameContentAs: (Array with: 'icon' with: #text with: 1).
					(Array with: #icon) sameContentAs: (Array with: 'text').
					(Array with: #icon) sameContentAs: (Array with: #icon with: #text).
					(Array with: #icon) sameContentAs: (OrderedCollection with: 'icon')} ].
	self assert: results asArray equals: #(true false false false).
	^ results
]

{ #category : #examples }
GtRemoteGemStoneSameContentAsExamples >> stringsAndSymbolsWithTheSameCharacters [
	"A String and a Symbol with the same characters have the same content"

	<gtExample>
	<after: #stopServer>
	| results |
	self runningServer
		gt4GemStoneUpToVersion: GtGemStoneSemanticVersionNumber v1_1_699
		do: [ ^ self ].

	results := self runningServer
			evaluateBlockAndWaitReturnPrimitive: [ {'abc' sameContentAs: #abc.
					#abc sameContentAs: 'abc'.
					#abc sameContentAs: #abc.
					'abc' sameContentAs: #abd.
					'abc' sameContentAs: 'ab'.
					'abc' sameContentAs: nil} ].
	self assert: results asArray equals: #(true true true false false false).
	^ results
]
