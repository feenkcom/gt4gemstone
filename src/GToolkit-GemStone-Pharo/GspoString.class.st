Class {
	#name : #GspoString,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GspoString class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ #String
]

{ #category : #accessing }
GspoString >> gtLiveFor: aView [
	<gtView>

	^ aView forward
		title: 'String';
		priority: 10;
		object: [ self limitedDisplayString ];
		view: #gtLiveFor:
]

{ #category : #accessing }
GspoString >> limitedDisplayString [
	"Answer the receiver, up to the first 1000 characters"

	^ self evaluateAndWait:
'self size < 1000
	ifTrue: [ self ]
	ifFalse: [ (self copyFrom: 1 to: 997), ''...'' ]'
]

{ #category : #accessing }
GspoString >> size [

	^ self proxyPerform: #size autoCommit: false
]
