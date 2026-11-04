Class {
	#name : #GtGemStoneNoLogoutPostponement,
	#superclass : #GtGemStoneAbstractLogoutPostponement,
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #accessing }
GtGemStoneNoLogoutPostponement >> description [

	^ 'Not postponed'

]

{ #category : #testing }
GtGemStoneNoLogoutPostponement >> hasBeenPostponed [

	^ false

]

{ #category : #testing }
GtGemStoneNoLogoutPostponement >> isPostponedAt: aDateAndTime [

	^ false

]

{ #category : #accessing }
GtGemStoneNoLogoutPostponement >> logoutTimeAfter: aDateAndTime [

	^ aDateAndTime

]
