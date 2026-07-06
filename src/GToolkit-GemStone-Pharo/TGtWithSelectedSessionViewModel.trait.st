Trait {
	#name : #TGtWithSelectedSessionViewModel,
	#instVars : [
		'selectedSessionViewModel'
	],
	#category : #'GToolkit-GemStone-Pharo-Support'
}

{ #category : #'api - selected session view model' }
TGtWithSelectedSessionViewModel >> deselectSessionViewModel [
	<propertyUnsetter: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertyUnsetterTemplate'>
	| aPreviousSelectedSessionViewModel |

	self hasSelectedSessionViewModel
		ifFalse: [ ^ self ].

	aPreviousSelectedSessionViewModel := selectedSessionViewModel.
	selectedSessionViewModel := nil.
	self onPreviousSelectedSessionViewModelUnset: aPreviousSelectedSessionViewModel.
	self notifySelectedSessionViewModelChanged
]

{ #category : #'api - selected session view model' }
TGtWithSelectedSessionViewModel >> hasSelectedSessionViewModel [
	<return: #Boolean>
	<propertyTester: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertyTesterTemplate'>

	^ selectedSessionViewModel notNil
]

{ #category : #'api - selected session view model' }
TGtWithSelectedSessionViewModel >> notifySelectedSessionViewModelChanged [
	"Override this notify method to announce changes to the property"
	<propertyChangeNotifier: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#notifyPropertyChangedTemplate'>
]

{ #category : #'api - selected session view model' }
TGtWithSelectedSessionViewModel >> onNewSelectedSessionViewModelSet: aNewSelectedSessionViewModel [
	"Is sent after a new value of the selectedSessionViewModel is assigned"
	<propertySetHook: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onNewPropertySetHookTemplate'>
]

{ #category : #'api - selected session view model' }
TGtWithSelectedSessionViewModel >> onPreviousSelectedSessionViewModelUnset: aPreviousSelectedSessionViewModel [
	"Is sent after a previous value of the selectedSessionViewModel is de-assigned"
	<propertyUnsetHook: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onPreviousPropertyUnsetHookTemplate'>
]

{ #category : #'api - selected session view model' }
TGtWithSelectedSessionViewModel >> selectSessionViewModel: aNewSelectedSessionViewModel [
	<propertySetter: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertySetterTemplate'>

	(self hasSelectedSessionViewModel
		and: [ self selectedSessionViewModel = aNewSelectedSessionViewModel ])
			ifTrue: [ ^ self ].
	
	self hasSelectedSessionViewModel
		ifTrue: [
			| aPreviousSelectedSessionViewModel |
			aPreviousSelectedSessionViewModel := selectedSessionViewModel.
			selectedSessionViewModel := nil.
			self onPreviousSelectedSessionViewModelUnset: aPreviousSelectedSessionViewModel ].
	selectedSessionViewModel := aNewSelectedSessionViewModel.
	self onNewSelectedSessionViewModelSet: aNewSelectedSessionViewModel.
	self notifySelectedSessionViewModelChanged
]

{ #category : #'api - selected session view model' }
TGtWithSelectedSessionViewModel >> selectedSessionViewModel [
	<return: #GtGemStoneSessionViewModel>
	<propertyGetter: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#propertyGetterTemplate'>

	^ selectedSessionViewModel
]
