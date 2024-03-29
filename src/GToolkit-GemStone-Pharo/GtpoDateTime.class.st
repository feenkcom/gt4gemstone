Class {
	#name : #GtpoDateTime,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoDateTime class >> remoteClassName [

	^ #DateTime
]

{ #category : #converting }
GtpoDateTime >> asDateAndTime [

	^ DateAndTime fromSeconds: 
		(self proxyPerform: #asSeconds autoCommit: false)
]

{ #category : #ui }
GtpoDateTime >> gtDetailsFor: aView [
	<gtView>

	remoteSelf ifNil: [ ^ aView empty ].
	^ aView forward 
		title: 'Details';
		priority: 10;
		object: [ self asDateAndTime ];
		view: #gtViewDetailsIn:
]

{ #category : #printing }
GtpoDateTime >> printOn: aStream [

	remoteSelf ifNil: [ ^ super printOn: aStream ].
	aStream << (self proxyPerform: #printString autoCommit: false).
]
