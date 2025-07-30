Trait {
	#name : #TGtWithGemStoneSessionsViewModel,
	#instVars : [
		'gemStoneSessionsViewModel'
	],
	#category : #'GToolkit-GemStone-Pharo-Support'
}

{ #category : #'api - gem stone sessions view model' }
TGtWithGemStoneSessionsViewModel >> gemStoneSessionsViewModel [
	"Return a not-null gemStoneSessionsViewModel assigned to the receiver"
	<modelGetter: #sessions>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectGetterTemplate'>
	self
		assert: [ gemStoneSessionsViewModel notNil ]
		description: [ 'gemStoneSessionsViewModel should be initialized' ].

	^ gemStoneSessionsViewModel
]

{ #category : #'api - gem stone sessions view model' }
TGtWithGemStoneSessionsViewModel >> gemStoneSessionsViewModel: aGemStoneSessionsViewModel [
	"Set a not-null gemStoneSessionsViewModel assigned to the receiver"
	<modelSetter: #sessions>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectSetterTemplate'>
	self
		assert: [ aGemStoneSessionsViewModel notNil ]
		description: [ 'gemStoneSessionsViewModel must not be nil' ].

	gemStoneSessionsViewModel == aGemStoneSessionsViewModel
		ifTrue: [ ^ self ].

	gemStoneSessionsViewModel ifNotNil: [ self unsubscribeFromGemStoneSessionsViewModel ].
	gemStoneSessionsViewModel := aGemStoneSessionsViewModel.

	self onGemStoneSessionsViewModelChanged.
	self subscribeToGemStoneSessionsViewModel.
	self onPostGemStoneSessionsViewModelChanged
]

{ #category : #'api - gem stone sessions view model' }
TGtWithGemStoneSessionsViewModel >> hasGemStoneSessionsViewModel [
	"Return a true if nil is assigned to the receiver, false otherwise"
	<return: #Boolean>
	<modelTester: #sessions>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#hasObjectTemplate'>

	^ gemStoneSessionsViewModel notNil
]

{ #category : #'api - gem stone sessions view model' }
TGtWithGemStoneSessionsViewModel >> onGemStoneSessionsViewModelChanged [
	"Is sent when a new gemStoneSessionsViewModel is assigned to the receiver.
	Note: #onGemStoneSessionsViewModelChanged is sent before #subscribeToGemStoneSessionsViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostGemStoneSessionsViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
]

{ #category : #'api - gem stone sessions view model' }
TGtWithGemStoneSessionsViewModel >> onPostGemStoneSessionsViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToGemStoneSessionsViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onPostObjectChangedTemplate'>
]

{ #category : #'api - gem stone sessions view model' }
TGtWithGemStoneSessionsViewModel >> subscribeToGemStoneSessionsViewModel [
	"Is sent after a new gemStoneSessionsViewModel is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromGemStoneSessionsViewModel if the receiver subscribes to them"
	<modelSubscriber: #sessions>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
]

{ #category : #'api - gem stone sessions view model' }
TGtWithGemStoneSessionsViewModel >> unsubscribeFromGemStoneSessionsViewModel [
	"Is sent before a new gemStoneSessionsViewModel is assigned to the receiver.
	Objects that subscribe to gemStoneSessionsViewModel are required to implement this method."
	<modelUnsubscriber: #sessions>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
]
