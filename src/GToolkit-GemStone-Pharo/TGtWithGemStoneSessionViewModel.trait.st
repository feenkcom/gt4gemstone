Trait {
	#name : #TGtWithGemStoneSessionViewModel,
	#instVars : [
		'gemStoneSessionViewModel'
	],
	#category : #'GToolkit-GemStone-Pharo-Support'
}

{ #category : #'api - gem stone session view model' }
TGtWithGemStoneSessionViewModel >> gemStoneSessionViewModel [
	"Return a not-null gemStoneSessionViewModel assigned to the receiver"
	<modelGetter: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectGetterTemplate'>
	self
		assert: [ gemStoneSessionViewModel notNil ]
		description: [ 'gemStoneSessionViewModel should be initialized' ].

	^ gemStoneSessionViewModel
]

{ #category : #'api - gem stone session view model' }
TGtWithGemStoneSessionViewModel >> gemStoneSessionViewModel: aGemStoneSessionViewModel [
	"Set a not-null gemStoneSessionViewModel assigned to the receiver"
	<modelSetter: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectSetterTemplate'>
	self
		assert: [ aGemStoneSessionViewModel notNil ]
		description: [ 'gemStoneSessionViewModel must not be nil' ].

	gemStoneSessionViewModel == aGemStoneSessionViewModel
		ifTrue: [ ^ self ].

	gemStoneSessionViewModel ifNotNil: [ self unsubscribeFromGemStoneSessionViewModel ].
	gemStoneSessionViewModel := aGemStoneSessionViewModel.

	self onGemStoneSessionViewModelChanged.
	self subscribeToGemStoneSessionViewModel.
	self onPostGemStoneSessionViewModelChanged
]

{ #category : #'api - gem stone session view model' }
TGtWithGemStoneSessionViewModel >> hasGemStoneSessionViewModel [
	"Return a true if nil is assigned to the receiver, false otherwise"
	<return: #Boolean>
	<modelTester: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#hasObjectTemplate'>

	^ gemStoneSessionViewModel notNil
]

{ #category : #'api - gem stone session view model' }
TGtWithGemStoneSessionViewModel >> onGemStoneSessionViewModelChanged [
	"Is sent when a new gemStoneSessionViewModel is assigned to the receiver.
	Note: #onGemStoneSessionViewModelChanged is sent before #subscribeToGemStoneSessionViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostGemStoneSessionViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
]

{ #category : #'api - gem stone session view model' }
TGtWithGemStoneSessionViewModel >> onPostGemStoneSessionViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToGemStoneSessionViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onPostObjectChangedTemplate'>
]

{ #category : #'api - gem stone session view model' }
TGtWithGemStoneSessionViewModel >> subscribeToGemStoneSessionViewModel [
	"Is sent after a new gemStoneSessionViewModel is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromGemStoneSessionViewModel if the receiver subscribes to them"
	<modelSubscriber: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
]

{ #category : #'api - gem stone session view model' }
TGtWithGemStoneSessionViewModel >> unsubscribeFromGemStoneSessionViewModel [
	"Is sent before a new gemStoneSessionViewModel is assigned to the receiver.
	Objects that subscribe to gemStoneSessionViewModel are required to implement this method."
	<modelUnsubscriber: #session>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
]
