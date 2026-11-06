Class {
	#name : #GtGemStoneGemLogNoEnding,
	#superclass : #GtGemStoneAbstractGemLogEnding,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneGemLogNoEnding >> description [

	^ 'No end in the log'

]

{ #category : #accessing }
GtGemStoneGemLogNoEnding >> explanation [

	^ 'The log has no logout: the gem is still running, or it stopped without logging out, for example because it crashed or the operating system killed it.'

]
