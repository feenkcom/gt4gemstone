Class {
	#name : #GtGemStoneKeepAliveSessionsEvent,
	#superclass : #GtGemStoneKeepAliveEvent,
	#category : #'GToolkit-GemStone-Pharo-Beacon'
}

{ #category : #accessing }
GtGemStoneKeepAliveSessionsEvent class >> eventLabel [
	^ 'GemStone Sessions Keep Alive'
]

{ #category : #accessing }
GtGemStoneKeepAliveSessionsEvent >> gtTreeDescription [
	| count |
	
	count := self subEvents size.
	^ count asString
		, ' ',('session' asPluralBasedOn: count)
]

{ #category : #accessing }
GtGemStoneKeepAliveSessionsEvent >> gtViewSessionsFor: aView [
	<gtView>
	
	^ aView columnedList
		title: 'Sessions';
		priority: 5;
		items: [ self subEvents ];
		column: 'Session' text: [ :anEvent | anEvent session name ];
		column: 'Change type' text: [ :anEvent | anEvent changeType ];
		column: 'Timestamp' text: #timestamp;
		column: 'Duration' 
			text: [ :anEvent | anEvent duration ]
]
