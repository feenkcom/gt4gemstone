Extension { #name : 'RsrRemoteException' }

{ #category : '*GToolkit-GemStone-Pharo' }
RsrRemoteException >> gtSummaryFor: aView [
	<gtView>

	(messageText isNil and: [ stack isNil]) ifTrue: [ ^ aView empty ].
	^ aView textEditor 
		title: 'Summary';
		priority: 10;
		text: [ self summaryText ]
]

{ #category : '*GToolkit-GemStone-Pharo' }
RsrRemoteException >> summaryText [
	"Answer a formatted BlText summarising the receiver's exception"
	| text |

	text := (messageText ifNil: [ '' ]) asRopedText, String crlfcrlf asRopedText.
	stack ifNotNil: [ text := text, stack asRopedText glamorousCodeFont ].
	^ text
]
