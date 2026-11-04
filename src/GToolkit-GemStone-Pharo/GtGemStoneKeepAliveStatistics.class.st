Class {
	#name : #GtGemStoneKeepAliveStatistics,
	#superclass : #Object,
	#instVars : [
		'aborts',
		'changesFound',
		'busySkips',
		'transactionModeSkips',
		'autoAbortStops',
		'errors',
		'logoutSchedules',
		'postponements',
		'logouts'
	],
	#category : #'GToolkit-GemStone-Pharo-Registry'
}

{ #category : #accessing }
GtGemStoneKeepAliveStatistics >> aborts [

	^ aborts

]

{ #category : #accessing }
GtGemStoneKeepAliveStatistics >> autoAbortStops [

	^ autoAbortStops

]

{ #category : #accessing }
GtGemStoneKeepAliveStatistics >> busySkips [

	^ busySkips

]

{ #category : #accessing }
GtGemStoneKeepAliveStatistics >> changesFound [

	^ changesFound

]

{ #category : #accessing }
GtGemStoneKeepAliveStatistics >> errors [

	^ errors

]

{ #category : #ui }
GtGemStoneKeepAliveStatistics >> gtOperationsFor: aView [
	<gtView>

	^ aView columnedList
		title: 'Operations';
		priority: 10;
		items: [ self operationCounts ];
		column: 'Operation' text: [ :each | each description ];
		column: 'Count' text: [ :each | each count ] width: 60;
		column: 'Last time' text: [ :each |
			each hasOccurred
				ifTrue: [ each lastTime ]
				ifFalse: [ '-' ] ] width: 250;
		actionUpdateButton

]

{ #category : #initialization }
GtGemStoneKeepAliveStatistics >> initialize [

	super initialize.
	aborts := GtGemStoneKeepAliveOperationCount
		description: 'Aborted'.
	changesFound := GtGemStoneKeepAliveOperationCount
		description: 'Not aborted: changed'.
	busySkips := GtGemStoneKeepAliveOperationCount
		description: 'Skipped: busy'.
	transactionModeSkips := GtGemStoneKeepAliveOperationCount
		description: 'Skipped: not autoBegin'.
	autoAbortStops := GtGemStoneKeepAliveOperationCount
		description: 'Not aborted: max keep alive exceeded'.
	errors := GtGemStoneKeepAliveOperationCount
		description: 'Failed with an error'.
	logoutSchedules := GtGemStoneKeepAliveOperationCount
		description: 'Scheduled for auto-logout'.
	postponements := GtGemStoneKeepAliveOperationCount
		description: 'Auto-logout postponed'.
	logouts := GtGemStoneKeepAliveOperationCount
		description: 'Logged out'

]

{ #category : #accessing }
GtGemStoneKeepAliveStatistics >> logoutSchedules [

	^ logoutSchedules

]

{ #category : #accessing }
GtGemStoneKeepAliveStatistics >> logouts [

	^ logouts

]

{ #category : #accessing }
GtGemStoneKeepAliveStatistics >> operationCounts [

	^ OrderedCollection new
		add: aborts;
		add: changesFound;
		add: busySkips;
		add: transactionModeSkips;
		add: autoAbortStops;
		add: errors;
		add: logoutSchedules;
		add: postponements;
		add: logouts;
		yourself

]

{ #category : #accessing }
GtGemStoneKeepAliveStatistics >> postponements [

	^ postponements

]

{ #category : #accessing }
GtGemStoneKeepAliveStatistics >> transactionModeSkips [

	^ transactionModeSkips

]
