Class {
	#name : #GtGemStoneGemLogLostClientConnection,
	#superclass : #GtGemStoneAbstractGemLogFatalErrorEnding,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #testing }
GtGemStoneGemLogLostClientConnection class >> handlesErrorNumber: aNumberString [

	^ aNumberString = '4137'

]

{ #category : #accessing }
GtGemStoneGemLogLostClientConnection >> description [

	^ 'Connection to the client ended'

]

{ #category : #accessing }
GtGemStoneGemLogLostClientConnection >> explanation [

	^ 'The gem lost the connection to its client (error 4137). GT closing the session ends the log this way, so this is also how a normal logout looks; otherwise the network connection was lost.'

]
