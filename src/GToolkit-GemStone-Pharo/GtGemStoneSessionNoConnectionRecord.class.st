Class {
	#name : #GtGemStoneSessionNoConnectionRecord,
	#superclass : #GtGemStoneAbstractSessionConnectionRecord,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #adding }
GtGemStoneSessionNoConnectionRecord >> addFirstTo: anOrderedCollection [

]

{ #category : #testing }
GtGemStoneSessionNoConnectionRecord >> canPostponeAutoLogout [

	^ false

]

{ #category : #testing }
GtGemStoneSessionNoConnectionRecord >> canRecordConnectionLoss [
	^ false
]

{ #category : #accessing }
GtGemStoneSessionNoConnectionRecord >> connectionTime [

	^ nil

]

{ #category : #accessing }
GtGemStoneSessionNoConnectionRecord >> description [

	^ 'No connection'

]

{ #category : #accessing }
GtGemStoneSessionNoConnectionRecord >> disconnectionReason [

	^ GtGemStoneNullDisconnectionReason new

]

{ #category : #accessing }
GtGemStoneSessionNoConnectionRecord >> gemDetails [

	^ GtGemStoneNoGemDetails notRetrieved

]

{ #category : #testing }
GtGemStoneSessionNoConnectionRecord >> hasKeepAlive [

	^ false

]

{ #category : #testing }
GtGemStoneSessionNoConnectionRecord >> isLogoutPending [

	^ false

]

{ #category : #accessing }
GtGemStoneSessionNoConnectionRecord >> keepAlive [

	^ nil

]

{ #category : #recording }
GtGemStoneSessionNoConnectionRecord >> recordDisconnectionReason: aDisconnectionReason [

]
