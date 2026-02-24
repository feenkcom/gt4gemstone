Extension { #name : #RsrService }

{ #category : #'*GToolkit-GemStone' }
RsrService class >> gtClientGsServer [
	"Answer the receiver's client class on GT and server class on GS"

	^ self
		gtDo: [ self clientClass] 
		gemstoneDo: [ self serverClass ]
]
