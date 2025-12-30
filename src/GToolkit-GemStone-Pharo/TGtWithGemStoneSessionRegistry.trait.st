Trait {
	#name : #TGtWithGemStoneSessionRegistry,
	#instVars : [
		'gemStoneSessionRegistry'
	],
	#category : #'GToolkit-GemStone-Pharo-Support'
}

{ #category : #'api - gem stone session registry' }
TGtWithGemStoneSessionRegistry >> gemStoneSessionRegistry [
	"Return a not-null gemStoneSessionRegistry assigned to the receiver"
	<modelGetter: #sessionRegistry>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectGetterTemplate'>
	self
		assert: [ gemStoneSessionRegistry notNil ]
		description: [ 'gemStoneSessionRegistry should be initialized' ].

	^ gemStoneSessionRegistry
]

{ #category : #'api - gem stone session registry' }
TGtWithGemStoneSessionRegistry >> gemStoneSessionRegistry: aGemStoneSessionRegistry [
	"Set a not-null gemStoneSessionRegistry assigned to the receiver"
	<modelSetter: #sessionRegistry>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectSetterTemplate'>
	self
		assert: [ aGemStoneSessionRegistry notNil ]
		description: [ 'gemStoneSessionRegistry must not be nil' ].

	gemStoneSessionRegistry == aGemStoneSessionRegistry
		ifTrue: [ ^ self ].

	gemStoneSessionRegistry ifNotNil: [ self unsubscribeFromGemStoneSessionRegistry ].
	gemStoneSessionRegistry := aGemStoneSessionRegistry.

	self onGemStoneSessionRegistryChanged.
	self subscribeToGemStoneSessionRegistry.
	self onPostGemStoneSessionRegistryChanged
]

{ #category : #'api - gem stone session registry' }
TGtWithGemStoneSessionRegistry >> hasGemStoneSessionRegistry [
	"Return a true if nil is assigned to the receiver, false otherwise"
	<return: #Boolean>
	<modelTester: #sessionRegistry>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#hasObjectTemplate'>

	^ gemStoneSessionRegistry notNil
]

{ #category : #'api - gem stone session registry' }
TGtWithGemStoneSessionRegistry >> onGemStoneSessionRegistryChanged [
	"Is sent when a new gemStoneSessionRegistry is assigned to the receiver.
	Note: #onGemStoneSessionRegistryChanged is sent before #subscribeToGemStoneSessionRegistry
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostGemStoneSessionRegistryChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
]

{ #category : #'api - gem stone session registry' }
TGtWithGemStoneSessionRegistry >> onPostGemStoneSessionRegistryChanged [
	"I am an optional hook method that is sent after #subscribeToGemStoneSessionRegistry.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onPostObjectChangedTemplate'>
]

{ #category : #'api - gem stone session registry' }
TGtWithGemStoneSessionRegistry >> subscribeToGemStoneSessionRegistry [
	"Is sent after a new gemStoneSessionRegistry is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromGemStoneSessionRegistry if the receiver subscribes to them"
	<modelSubscriber: #sessionRegistry>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
]

{ #category : #'api - gem stone session registry' }
TGtWithGemStoneSessionRegistry >> unsubscribeFromGemStoneSessionRegistry [
	"Is sent before a new gemStoneSessionRegistry is assigned to the receiver.
	Objects that subscribe to gemStoneSessionRegistry are required to implement this method."
	<modelUnsubscriber: #sessionRegistry>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
]
