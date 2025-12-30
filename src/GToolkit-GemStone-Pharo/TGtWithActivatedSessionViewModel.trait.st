Trait {
	#name : #TGtWithActivatedSessionViewModel,
	#instVars : [
		'activatedSessionViewModel'
	],
	#category : #'GToolkit-GemStone-Pharo-Support'
}

{ #category : #'api - activated session view model' }
TGtWithActivatedSessionViewModel >> activateSessionViewModel: aNewActivatedSessionViewModel [
	<propertySetter: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertySetterTemplate'>

	(self hasActivatedSessionViewModel
		and: [ self activatedSessionViewModel = aNewActivatedSessionViewModel ])
			ifTrue: [ ^ self ].
	
	self hasActivatedSessionViewModel
		ifTrue: [
			| aPreviousActivatedSessionViewModel |
			aPreviousActivatedSessionViewModel := activatedSessionViewModel.
			activatedSessionViewModel := nil.
			self onPreviousActivatedSessionViewModelUnset: aPreviousActivatedSessionViewModel ].
	activatedSessionViewModel := aNewActivatedSessionViewModel.
	self onNewActivatedSessionViewModelSet: aNewActivatedSessionViewModel.
	self notifyActivatedSessionViewModelChanged
]

{ #category : #'api - activated session view model' }
TGtWithActivatedSessionViewModel >> activatedSessionViewModel [
	<return: #GtGemStoneSessionViewModel>
	<propertyGetter: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertyGetterTemplate'>

	^ activatedSessionViewModel
]

{ #category : #'api - activated session view model' }
TGtWithActivatedSessionViewModel >> deactivateSessionViewModel [
	<propertyUnsetter: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertyUnsetterTemplate'>
	| aPreviousActivatedSessionViewModel |

	self hasActivatedSessionViewModel
		ifFalse: [ ^ self ].

	aPreviousActivatedSessionViewModel := activatedSessionViewModel.
	activatedSessionViewModel := nil.
	self onPreviousActivatedSessionViewModelUnset: aPreviousActivatedSessionViewModel.
	self notifyActivatedSessionViewModelChanged
]

{ #category : #'api - activated session view model' }
TGtWithActivatedSessionViewModel >> hasActivatedSessionViewModel [
	<return: #Boolean>
	<propertyTester: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertyTesterTemplate'>

	^ activatedSessionViewModel notNil
]

{ #category : #'api - activated session view model' }
TGtWithActivatedSessionViewModel >> notifyActivatedSessionViewModelChanged [
	"Override this notify method to announce changes to the property"
	<propertyChangeNotifier: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#notifyPropertyChangedTemplate'>
]

{ #category : #'api - activated session view model' }
TGtWithActivatedSessionViewModel >> onNewActivatedSessionViewModelSet: aNewActivatedSessionViewModel [
	"Is sent after a new value of the activatedSessionViewModel is assigned"
	<propertySetHook: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onNewPropertySetHookTemplate'>
]

{ #category : #'api - activated session view model' }
TGtWithActivatedSessionViewModel >> onPreviousActivatedSessionViewModelUnset: aPreviousActivatedSessionViewModel [
	"Is sent after a previous value of the activatedSessionViewModel is de-assigned"
	<propertyUnsetHook: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onPreviousPropertyUnsetHookTemplate'>
]
