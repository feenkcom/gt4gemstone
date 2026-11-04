Class {
	#name : #GtGemStoneLogoutPendingRowAptitude,
	#superclass : #BrLazyStyleCommonAptitude,
	#instVars : [
		'isLogoutPending'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #accessing }
GtGemStoneLogoutPendingRowAptitude class >> backgroundColor [

	^ BrGlamorousColors failureBackgroundColor

]

{ #category : #binding }
GtGemStoneLogoutPendingRowAptitude class >> bindRow: aRowElement toSession: aGtGemStoneSession [

	(aRowElement userData
		at: #gtGemStoneLogoutPendingRowAptitude
		ifAbsentPut: [
			| anAptitude |
			anAptitude := self new.
			aRowElement addAptitude: anAptitude.
			anAptitude ])
				isLogoutPending: aGtGemStoneSession isLogoutPending

]

{ #category : #accessing }
GtGemStoneLogoutPendingRowAptitude class >> hoveredBackgroundColor [

	^ self backgroundColor darker

]

{ #category : #accessing }
GtGemStoneLogoutPendingRowAptitude class >> selectedBackgroundColor [

	^ self hoveredBackgroundColor darker

]

{ #category : #initialization }
GtGemStoneLogoutPendingRowAptitude >> initialize [

	super initialize.
	isLogoutPending := false.
	self
		default: [ :aStyle |
			isLogoutPending ifTrue: [ aStyle background: self class backgroundColor ] ];
		hovered: [ :aStyle |
			isLogoutPending ifTrue: [ aStyle background: self class hoveredBackgroundColor ] ];
		pressed: [ :aStyle |
			isLogoutPending ifTrue: [ aStyle background: self class selectedBackgroundColor ] ];
		selected: [ :aStyle |
			isLogoutPending ifTrue: [ aStyle background: self class selectedBackgroundColor ] ]

]

{ #category : #accessing }
GtGemStoneLogoutPendingRowAptitude >> isLogoutPending [

	^ isLogoutPending

]

{ #category : #accessing }
GtGemStoneLogoutPendingRowAptitude >> isLogoutPending: aBoolean [

	isLogoutPending = aBoolean ifTrue: [ ^ self ].
	self updateWith: [ isLogoutPending := aBoolean ]

]
