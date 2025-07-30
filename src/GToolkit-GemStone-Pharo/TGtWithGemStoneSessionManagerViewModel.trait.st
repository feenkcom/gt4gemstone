Trait {
	#name : #TGtWithGemStoneSessionManagerViewModel,
	#instVars : [
		'gemStoneSessionManagerViewModel'
	],
	#category : #'GToolkit-GemStone-Pharo-Support'
}

{ #category : #'api - gem stone session manager view model' }
TGtWithGemStoneSessionManagerViewModel >> gemStoneSessionManagerViewModel [
	"Return a not-null gemStoneSessionManagerViewModel assigned to the receiver"
	<modelGetter: #sessionManager>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectGetterTemplate'>
	self
		assert: [ gemStoneSessionManagerViewModel notNil ]
		description: [ 'gemStoneSessionManagerViewModel should be initialized' ].

	^ gemStoneSessionManagerViewModel
]

{ #category : #'api - gem stone session manager view model' }
TGtWithGemStoneSessionManagerViewModel >> gemStoneSessionManagerViewModel: aGemStoneSessionManagerViewModel [
	"Set a not-null gemStoneSessionManagerViewModel assigned to the receiver"
	<modelSetter: #sessionManager>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectSetterTemplate'>
	self
		assert: [ aGemStoneSessionManagerViewModel notNil ]
		description: [ 'gemStoneSessionManagerViewModel must not be nil' ].

	gemStoneSessionManagerViewModel == aGemStoneSessionManagerViewModel
		ifTrue: [ ^ self ].

	gemStoneSessionManagerViewModel ifNotNil: [ self unsubscribeFromGemStoneSessionManagerViewModel ].
	gemStoneSessionManagerViewModel := aGemStoneSessionManagerViewModel.

	self onGemStoneSessionManagerViewModelChanged.
	self subscribeToGemStoneSessionManagerViewModel.
	self onPostGemStoneSessionManagerViewModelChanged
]

{ #category : #'api - gem stone session manager view model' }
TGtWithGemStoneSessionManagerViewModel >> hasGemStoneSessionManagerViewModel [
	"Return a true if nil is assigned to the receiver, false otherwise"
	<return: #Boolean>
	<modelTester: #sessionManager>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#hasObjectTemplate'>

	^ gemStoneSessionManagerViewModel notNil
]

{ #category : #'api - gem stone session manager view model' }
TGtWithGemStoneSessionManagerViewModel >> onGemStoneSessionManagerViewModelChanged [
	"Is sent when a new gemStoneSessionManagerViewModel is assigned to the receiver.
	Note: #onGemStoneSessionManagerViewModelChanged is sent before #subscribeToGemStoneSessionManagerViewModel
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostGemStoneSessionManagerViewModelChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
]

{ #category : #'api - gem stone session manager view model' }
TGtWithGemStoneSessionManagerViewModel >> onPostGemStoneSessionManagerViewModelChanged [
	"I am an optional hook method that is sent after #subscribeToGemStoneSessionManagerViewModel.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onPostObjectChangedTemplate'>
]

{ #category : #'api - gem stone session manager view model' }
TGtWithGemStoneSessionManagerViewModel >> subscribeToGemStoneSessionManagerViewModel [
	"Is sent after a new gemStoneSessionManagerViewModel is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromGemStoneSessionManagerViewModel if the receiver subscribes to them"
	<modelSubscriber: #sessionManager>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
]

{ #category : #'api - gem stone session manager view model' }
TGtWithGemStoneSessionManagerViewModel >> unsubscribeFromGemStoneSessionManagerViewModel [
	"Is sent before a new gemStoneSessionManagerViewModel is assigned to the receiver.
	Objects that subscribe to gemStoneSessionManagerViewModel are required to implement this method."
	<modelUnsubscriber: #sessionManager>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
]
