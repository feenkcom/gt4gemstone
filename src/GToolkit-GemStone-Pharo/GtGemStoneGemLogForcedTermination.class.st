Class {
	#name : #GtGemStoneGemLogForcedTermination,
	#superclass : #GtGemStoneAbstractGemLogFatalErrorEnding,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #testing }
GtGemStoneGemLogForcedTermination class >> handlesErrorNumber: aNumberString [

	^ aNumberString = '4059'

]

{ #category : #accessing }
GtGemStoneGemLogForcedTermination >> description [

	^ 'Terminated by GemStone'

]

{ #category : #accessing }
GtGemStoneGemLogForcedTermination >> explanation [

	^ 'GemStone stopped the session: another session called System stopSession: on it (error 4059). A stack print shortly before the end usually means that a cleanup of sessions that stayed too long in a transaction printed its stack first and then stopped it.'

]

{ #category : #testing }
GtGemStoneGemLogForcedTermination >> isTerminatedByGemStone [

	^ true

]
