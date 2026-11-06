Class {
	#name : #GtGemStoneGemLogOtherFatalError,
	#superclass : #GtGemStoneAbstractGemLogFatalErrorEnding,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneGemLogOtherFatalError >> description [

	^ 'Fatal error ' , errorNumber

]

{ #category : #accessing }
GtGemStoneGemLogOtherFatalError >> explanation [

	^ 'The gem ended with GemStone error ' , errorNumber , ': ' , errorText

]
