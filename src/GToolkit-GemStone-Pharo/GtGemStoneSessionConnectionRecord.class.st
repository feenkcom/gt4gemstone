Class {
	#name : #GtGemStoneSessionConnectionRecord,
	#superclass : #GtGemStoneAbstractSessionConnectionRecord,
	#instVars : [
		'sessionName',
		'connectionTime',
		'keepAlive',
		'disconnectionReason'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #'instance creation' }
GtGemStoneSessionConnectionRecord class >> session: aGtGemStoneSession [

	^ self new initializeWithSession: aGtGemStoneSession

]

{ #category : #adding }
GtGemStoneSessionConnectionRecord >> addFirstTo: anOrderedCollection [

	anOrderedCollection addFirst: self

]

{ #category : #testing }
GtGemStoneSessionConnectionRecord >> canPostponeAutoLogout [

	^ keepAlive canPostponeAutoLogout

]

{ #category : #testing }
GtGemStoneSessionConnectionRecord >> canRecordConnectionLoss [

	^ self hasEnded not

]

{ #category : #accessing }
GtGemStoneSessionConnectionRecord >> connectedDuration [

	^ disconnectionReason time - connectionTime

]

{ #category : #accessing }
GtGemStoneSessionConnectionRecord >> connectionTime [

	^ connectionTime

]

{ #category : #accessing }
GtGemStoneSessionConnectionRecord >> description [

	^ sessionName , ', connected at ' , connectionTime asTime print24 , ': ' , self stateDescription

]

{ #category : #accessing }
GtGemStoneSessionConnectionRecord >> disconnectionReason [

	^ disconnectionReason

]

{ #category : #ui }
GtGemStoneSessionConnectionRecord >> gtConnectionDetailsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Connection details';
		priority: 10;
		items: [ self recordAttributes ];
		column: 'Attribute' text: #key;
		column: 'Value' text: #value;
		send: #value;
		actionUpdateButton

]

{ #category : #ui }
GtGemStoneSessionConnectionRecord >> gtKeepAliveFor: aView [
	<gtView>

	^ aView forward
		title: 'Keep alive';
		priority: 20;
		object: [ keepAlive ];
		view: #gtKeepAliveFor:

]

{ #category : #ui }
GtGemStoneSessionConnectionRecord >> gtOperationsFor: aView [
	<gtView>

	^ aView forward
		title: 'Operations';
		priority: 25;
		object: [ self statistics ];
		view: #gtOperationsFor:

]

{ #category : #testing }
GtGemStoneSessionConnectionRecord >> hasEnded [

	^ disconnectionReason isKnown

]

{ #category : #testing }
GtGemStoneSessionConnectionRecord >> hasKeepAlive [

	^ true

]

{ #category : #initialization }
GtGemStoneSessionConnectionRecord >> initializeWithSession: aGtGemStoneSession [

	sessionName := aGtGemStoneSession name.
	connectionTime := aGtGemStoneSession connectionTime.
	disconnectionReason := GtGemStoneNullDisconnectionReason new.
	keepAlive := aGtGemStoneSession createKeepAlive.
	keepAlive connectionRecord: self

]

{ #category : #testing }
GtGemStoneSessionConnectionRecord >> isCurrent [

	^ keepAlive session connectionRecord == self

]

{ #category : #testing }
GtGemStoneSessionConnectionRecord >> isLogoutPending [

	^ keepAlive isLogoutPending

]

{ #category : #accessing }
GtGemStoneSessionConnectionRecord >> keepAlive [

	^ keepAlive

]

{ #category : #accessing }
GtGemStoneSessionConnectionRecord >> recordAttributes [
	| attributes |

	attributes := OrderedCollection new.
	attributes
		add: 'Session' -> sessionName;
		add: 'Connected at' -> connectionTime;
		add: 'State' -> self stateDescription.
	self hasEnded ifTrue: [
		attributes add: 'Connected for' -> self connectedDuration gtHumanReadableString ].
	attributes addAll: disconnectionReason detailAttributes.
	attributes
		add: 'Aborts by the keep alive' -> self statistics aborts count;
		add: 'Dirty count at the last poll' -> keepAlive dirtyCount;
		add: 'Max keep alive (minutes)' -> keepAlive maxKeepAlive;
		add: 'Postponement' -> keepAlive postponement description.
	^ attributes

]

{ #category : #recording }
GtGemStoneSessionConnectionRecord >> recordDisconnectionReason: aDisconnectionReason [

	self hasEnded ifFalse: [
		disconnectionReason := aDisconnectionReason ]

]

{ #category : #accessing }
GtGemStoneSessionConnectionRecord >> sessionName [

	^ sessionName

]

{ #category : #accessing }
GtGemStoneSessionConnectionRecord >> stateDescription [

	^ keepAlive stateDescription

]

{ #category : #accessing }
GtGemStoneSessionConnectionRecord >> statistics [

	^ keepAlive statistics

]

{ #category : #accessing }
GtGemStoneSessionConnectionRecord >> summary [

	^ String streamContents: [ :aStream |
		aStream
			nextPutAll: sessionName;
			nextPutAll: ' at ';
			nextPutAll: disconnectionReason timeDescription;
			nextPutAll: ', connected for ';
			nextPutAll: self connectedDuration gtHumanReadableString;
			space.
		aStream parenthesize: [
			aStream nextPutAll: disconnectionReason causeDescription.
			keepAlive hasBeenPostponed ifTrue: [
				aStream
					nextPutAll: ', ';
					nextPutAll: keepAlive postponementDescription ].
			disconnectionReason hadUncommittedChanges ifTrue: [
				aStream nextPutAll: ', uncommitted changes were discarded' ] ] ]

]
