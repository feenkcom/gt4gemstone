Class {
	#name : #GspoString,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GspoString class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ #String
]

{ #category : #accessing }
GspoString >> gtCharactersFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Characters';
		priority: 16;
		items: [ self gtSession
				evaluateAsRemoteStreamBlock: [ :each | each ] withArguments: {self} ];
		actionUpdateButtonTooltip: 'Update item list';
		column: 'Index'
			text: [ :eachItem :eachIndex | eachIndex asRopedText foreground: Color gray ]
			width: 45;
		column: 'Character'
			stencil: [ :each | 
				BrEditor new
					beReadOnlyWithoutSelection;
					preventMeAndChildrenMouseEvents;
					aptitude: BrGlamorousRegularEditorAptitude new;
					hMatchParent;
					padding: (BlInsets left: 5);
					vExact: 20;
					text: (each gtDisplayString gtRemovePrefix: 'Character ') ]
			width: 100;
		column: 'ASCII'
			text: [ :eachItem | eachItem asciiValue ]
			width: 100;
		column: 'UTF-8 code point'
			text: [ :eachItem | 
				[ eachItem unicodeCharacterData gtCodePointHexString ]
					on: NotFound
					do: [ 'N/A' ] ]
			width: 150;
		column: 'UTF-8 hex'
			text: [ :each | 
				String
					streamContents: [ :out | 
						each asString utf8Encoded
							do: [ :byte | 
								byte
									printOn: out
									base: 16
									nDigits: 2 ]
							separatedBy: [ out space ] ] ]
			width: 100;
		column: 'UTF-8 binary'
			text: [ :each | 
				[ each value unicodeCharacterData asTextWithUtf8EncodedBinary ]
					on: NotFound
					do: [ 'N/A' ] ];
		send: [ :each :selection |
			(self proxyPerformReturnProxy: #at: withArguments: {selection first}) asGtBareProxyObject  ]
]

{ #category : #accessing }
GspoString >> gtHexDumpFor: aView [
	<gtView>

	^ aView forward
			title: 'Hex dump';
			priority: 70;
			object: [ self limitedDisplayString  ];
			view: #gtHexDumpFor:
]

{ #category : #accessing }
GspoString >> gtLiveFor: aView [
	<gtView>

	^ aView forward
		title: 'Live';
		priority: 10;
		object: [ self limitedDisplayString ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GspoString >> limitedDisplayString [
	"Answer the receiver, up to the first 1000 characters"

	^ self evaluateAndWait:
'self size < 10000
	ifTrue: [ self ]
	ifFalse: [ (self copyFrom: 1 to: 9997), ''...'' ]'
]

{ #category : #accessing }
GspoString >> size [

	^ self proxyPerform: #size autoCommit: false
]
