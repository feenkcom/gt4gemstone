Extension { #name : #RsrBrokenPromise }

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrBrokenPromise >> debuggerClient [

	^ reason debuggerClient
]

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrBrokenPromise >> gtMessageTextFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Message';
		priority: 2;
		text: [ self messageText ifEmpty: [ reason summaryText ] ]
]
