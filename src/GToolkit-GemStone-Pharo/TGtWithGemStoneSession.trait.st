Trait {
	#name : #TGtWithGemStoneSession,
	#instVars : [
		'gemStoneSession'
	],
	#category : #'GToolkit-GemStone-Pharo-Support'
}

{ #category : #'api - gem stone session' }
TGtWithGemStoneSession >> gemStoneSession [
	"Return a not-null gemStoneSession assigned to the receiver"
	<modelGetter: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectGetterTemplate'>
	self
		assert: [ gemStoneSession notNil ]
		description: [ 'gemStoneSession should be initialized' ].

	^ gemStoneSession
]

{ #category : #'api - gem stone session' }
TGtWithGemStoneSession >> gemStoneSession: aGemStoneSession [
	"Set a not-null gemStoneSession assigned to the receiver"
	<modelSetter: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectSetterTemplate'>
	self
		assert: [ aGemStoneSession notNil ]
		description: [ 'gemStoneSession must not be nil' ].

	gemStoneSession == aGemStoneSession
		ifTrue: [ ^ self ].

	gemStoneSession ifNotNil: [ self unsubscribeFromGemStoneSession ].
	gemStoneSession := aGemStoneSession.

	self onGemStoneSessionChanged.
	self subscribeToGemStoneSession.
	self onPostGemStoneSessionChanged
]

{ #category : #'api - gem stone session' }
TGtWithGemStoneSession >> hasGemStoneSession [
	"Return a true if nil is assigned to the receiver, false otherwise"
	<return: #Boolean>
	<modelTester: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#hasObjectTemplate'>

	^ gemStoneSession notNil
]

{ #category : #'api - gem stone session' }
TGtWithGemStoneSession >> onGemStoneSessionChanged [
	"Is sent when a new gemStoneSession is assigned to the receiver.
	Note: #onGemStoneSessionChanged is sent before #subscribeToGemStoneSession
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostGemStoneSessionChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
]

{ #category : #'api - gem stone session' }
TGtWithGemStoneSession >> onPostGemStoneSessionChanged [
	"I am an optional hook method that is sent after #subscribeToGemStoneSession.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onPostObjectChangedTemplate'>
]

{ #category : #'api - gem stone session' }
TGtWithGemStoneSession >> subscribeToGemStoneSession [
	"Is sent after a new gemStoneSession is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromGemStoneSession if the receiver subscribes to them"
	<modelSubscriber: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
]

{ #category : #'api - gem stone session' }
TGtWithGemStoneSession >> unsubscribeFromGemStoneSession [
	"Is sent before a new gemStoneSession is assigned to the receiver.
	Objects that subscribe to gemStoneSession are required to implement this method."
	<modelUnsubscriber: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
]
