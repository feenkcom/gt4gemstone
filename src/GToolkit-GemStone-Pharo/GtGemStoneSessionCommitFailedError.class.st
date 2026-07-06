Class {
	#name : #GtGemStoneSessionCommitFailedError,
	#superclass : #GtGemStoneSessionError,
	#instVars : [
		'transactionConflictsReport',
		'transactionConflicts'
	],
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GtGemStoneSessionCommitFailedError >> gemStoneSession: aGemStoneSession [
	| conflictsData |
	super gemStoneSession: aGemStoneSession.
	
	conflictsData := aGemStoneSession transactionConflictsData.
	transactionConflicts := conflictsData at: 'transactionConflicts'.
	messageText := 'Commit result: ', (conflictsData at: 'commitResult')
]

{ #category : #'gt - extensions' }
GtGemStoneSessionCommitFailedError >> gtViewTransactionConflictsFor: aView [ 
	<gtView>
	<gtExceptionView>
	
	^ aView remoteForward
		title: 'Transaction Conflicts';
		priority: 5;
		object: [ transactionConflicts ];
		view: #gtItemsFor:
]

{ #category : #accessing }
GtGemStoneSessionCommitFailedError >> transactionConflicts [
	^ transactionConflicts
]
