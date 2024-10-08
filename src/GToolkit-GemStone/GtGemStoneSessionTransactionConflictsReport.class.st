Class {
	#name : #GtGemStoneSessionTransactionConflictsReport,
	#superclass : #Object,
	#instVars : [
		'transactionConflicts'
	],
	#category : #'GToolkit-GemStone'
}

{ #category : #'instance - creation' }
GtGemStoneSessionTransactionConflictsReport class >> forCurrentConflicts [
	^ self new initializeFromCurrentConflicts
]

{ #category : #accessing }
GtGemStoneSessionTransactionConflictsReport >> commitResult [ 
	^ transactionConflicts  
		at: #commitResult
		ifAbsent: [ 'unknown' ]
]

{ #category : #'gt - extensions' }
GtGemStoneSessionTransactionConflictsReport >> gtViewTransactionConflictsFor: aView [ 
	<gtView>
	
	^ aView forward
		title: 'Transaction Conflicts';
		priority: 5;
		object: [ transactionConflicts ];
		view: #gtItemsFor:
]

{ #category : #initialization }
GtGemStoneSessionTransactionConflictsReport >> initializeFromCurrentConflicts [
	transactionConflicts := System transactionConflicts
]

{ #category : #printing }
GtGemStoneSessionTransactionConflictsReport >> printOn: aStream [
	super printOn: aStream.
	
	aStream parenthesize: [
		aStream << self commitResult asString ]
]

{ #category : #converting }
GtGemStoneSessionTransactionConflictsReport >> reportDictionaryForExport [
	^ Dictionary new
		at: 'commitResult' put: self commitResult;
		at: 'conflictsReport'
			put: (self asGtRsrProxyObjectForConnection: nil);
		yourself
]

{ #category : #accessing }
GtGemStoneSessionTransactionConflictsReport >> transactionConflicts [
	^ transactionConflicts
]
