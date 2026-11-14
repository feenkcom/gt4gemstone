Extension { #name : #GtDebuggerReport }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtDebuggerReport >> gtGemStoneStackFor: aView [
	"Show the remote stack saved from a GemStone debugger (see GtGemStoneDebuggerSession>>#debuggerReportStacks)"

	<gtView>
	| aRemoteStack |
	aRemoteStack := self
			stackNamed: GtGemStoneDebuggerSession remoteStackReportName
			ifNone: [ ^ aView empty ].
	^ aView forward
		title: 'GemStone stack';
		priority: 11;
		object: [ aRemoteStack ];
		view: #gtTextFor:
]
