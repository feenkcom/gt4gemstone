Class {
	#name : #GtGemStoneLogoutPostponement,
	#superclass : #GtGemStoneAbstractLogoutPostponement,
	#instVars : [
		'postponedAt',
		'until'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #'instance creation' }
GtGemStoneLogoutPostponement class >> postponedAt: aDateAndTime until: anotherDateAndTime [

	^ self new initializeWithPostponedAt: aDateAndTime until: anotherDateAndTime

]

{ #category : #accessing }
GtGemStoneLogoutPostponement >> description [

	^ 'Postponed at ' , postponedAt asTime print24 , ' until ' , until asTime print24

]

{ #category : #accessing }
GtGemStoneLogoutPostponement >> duration [

	^ until - postponedAt

]

{ #category : #testing }
GtGemStoneLogoutPostponement >> hasBeenPostponed [

	^ true

]

{ #category : #initialization }
GtGemStoneLogoutPostponement >> initializeWithPostponedAt: aDateAndTime until: anotherDateAndTime [

	postponedAt := aDateAndTime.
	until := anotherDateAndTime

]

{ #category : #testing }
GtGemStoneLogoutPostponement >> isPostponedAt: aDateAndTime [

	^ aDateAndTime < until

]

{ #category : #accessing }
GtGemStoneLogoutPostponement >> logoutTimeAfter: aDateAndTime [

	^ aDateAndTime max: until

]

{ #category : #accessing }
GtGemStoneLogoutPostponement >> postponedAt [

	^ postponedAt

]

{ #category : #accessing }
GtGemStoneLogoutPostponement >> until [

	^ until

]
