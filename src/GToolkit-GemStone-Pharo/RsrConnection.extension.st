Extension { #name : #RsrConnection }

{ #category : #'*GToolkit-GemStone-Pharo' }
RsrConnection >> isBusy [

	^ pendingMessages isEmpty not
]
