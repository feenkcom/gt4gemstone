Class {
	#name : 'GtpoDateTime',
	#superclass : 'GtRsrProxyServiceClient',
	#category : 'GToolkit-GemStone-Pharo'
}

{ #category : 'accessing' }
GtpoDateTime class >> remoteClassName [

	^ #DateTime
]

{ #category : 'converting' }
GtpoDateTime >> asDateAndTime [

	^ DateAndTime fromSeconds: (self proxyPerform: #asSeconds)
]

{ #category : 'ui' }
GtpoDateTime >> gtDetailsFor: aView [
	<gtView>

	remoteSelf ifNil: [ ^ aView empty ].
	^ aView forward 
		title: 'Details';
		priority: 10;
		object: [ self asDateAndTime ];
		view: #gtViewDetailsIn:
]

{ #category : 'printing' }
GtpoDateTime >> printOn: aStream [

	remoteSelf ifNil: [ ^ super printOn: aStream ].
	aStream << (self proxyPerform: #printString).
]
