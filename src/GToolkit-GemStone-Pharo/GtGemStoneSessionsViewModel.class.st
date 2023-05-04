Class {
	#name : #GtGemStoneSessionsViewModel,
	#superclass : #Object,
	#traits : 'TGtWithSelectedSessionViewModel + TGtWithActivatedSessionViewModel',
	#classTraits : 'TGtWithSelectedSessionViewModel classTrait + TGtWithActivatedSessionViewModel classTrait',
	#instVars : [
		'activeSessions',
		'parentGemStoneSessionManagerViewModel',
		'gemStoneSessionViewModels',
		'announcer'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #'api - active sessions' }
GtGemStoneSessionsViewModel >> activeSessions [
	"Return a not-null activeSessions assigned to the receiver"
	<modelGetter: #activeSessions>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectGetterTemplate'>
	self
		assert: [ activeSessions notNil ]
		description: [ 'activeSessions should be initialized' ].

	^ activeSessions
]

{ #category : #'api - active sessions' }
GtGemStoneSessionsViewModel >> activeSessions: aActiveSessions [
	"Set a not-null activeSessions assigned to the receiver"
	<modelSetter: #activeSessions>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#objectSetterTemplate'>
	self
		assert: [ aActiveSessions notNil ]
		description: [ 'activeSessions must not be nil' ].

	activeSessions == aActiveSessions
		ifTrue: [ ^ self ].

	activeSessions ifNotNil: [ self unsubscribeFromActiveSessions ].
	activeSessions := aActiveSessions.
	gemStoneSessionViewModels := nil.

	self onActiveSessionsChanged.
	self subscribeToActiveSessions.
	self onPostActiveSessionsChanged
]

{ #category : #'api - announcer' }
GtGemStoneSessionsViewModel >> announce: anAnnouncement [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#announceTemplate'>
	announcer ifNotNil: [ :anAnnouncer | anAnnouncer announce: anAnnouncement ].
	"Dispatch anAnnouncement to the parent objects if they are assigned"
	self hasParentGemStoneSessionManagerViewModel
		ifTrue: [ self parentGemStoneSessionManagerViewModel announce: anAnnouncement ].
]

{ #category : #'private - instance creation' }
GtGemStoneSessionsViewModel >> createGemStoneSessionViewModels [
	"For each child from the domain model create an object and return a resulting collection"
	<return: #Collection of: #GtGemStoneSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelChildrenForManyWithModelTemplate>>#createChildObjectsTemplate'>

	^ self activeSessions yourself collect: [ :eachModel |
		self createGemStoneSessionViewModelsFor: eachModel ] as: OrderedCollection
]

{ #category : #'private - instance creation' }
GtGemStoneSessionsViewModel >> createGemStoneSessionViewModelsFor: aChildModel [
	<return: #GtGemStoneSessionViewModel>
	<childObjectCreator: #session>
	<generatedFrom: #'TGtRobocoderMetamodelChildrenForManyWithModelTemplate>>#createChildTemplate'>
	| aNewChild |
	
	aNewChild := GtGemStoneSessionViewModel new.
	aNewChild parentGemStoneSessionsViewModel: self.
	aNewChild gemStoneSession: aChildModel.
	^ aNewChild
]

{ #category : #'api - activation' }
GtGemStoneSessionsViewModel >> deactivateAllFromTopMostParent [
	"Deactivate any activated child starting from the top most parent"
	<propertyUnsetFromParent: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetAllFromTopMostParentTemplate'>
	
	self topMostParentsWithActivationDo: [ :eachParent | eachParent deactivateChildren ]
]

{ #category : #'api - activation' }
GtGemStoneSessionsViewModel >> deactivateChildren [
	"Deactivate any activated child"
	<propertyUnsetChildren: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetChildrenTemplate'>
	self deactivateSessionViewModel.
]

{ #category : #'api - selection' }
GtGemStoneSessionsViewModel >> deselectAllFromTopMostParent [
	"Deselect any selected child starting from the top most parent"
	<propertyUnsetFromParent: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetAllFromTopMostParentTemplate'>
	
	self topMostParentsWithSelectionDo: [ :eachParent | eachParent deselectChildren ]
]

{ #category : #'api - selection' }
GtGemStoneSessionsViewModel >> deselectChildren [
	"Deselect any selected child"
	<propertyUnsetChildren: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetChildrenTemplate'>
	self deselectSessionViewModel.
]

{ #category : #'api - accessing' }
GtGemStoneSessionsViewModel >> findGemStoneSessionViewModels: aSession [
	"Find a child object based on the child model and return the child if it was found, nil otherwise.
	aNoneBlock otherwise."
	<return: #GtGemStoneSessionViewModel or: nil>
	<childObjectDetector: #session>
	<generatedFrom: #'TGtRobocoderMetamodelChildrenForManyWithModelTemplate>>#findObjectTemplate'>

	^ self
		findGemStoneSessionViewModels: aSession
		ifFound: [ :aGemStoneSessionViewModels | aGemStoneSessionViewModels ]
		ifNone: [ nil ]
]

{ #category : #'api - accessing' }
GtGemStoneSessionsViewModel >> findGemStoneSessionViewModels: aSession ifFound: aFoundBlock ifNone: aNoneBlock [
	"Find a child object based on the child model and evaluate aFoundBlock if such child was found,
	aNoneBlock otherwise."
	<return: #Object>
	<generatedFrom: #'TGtRobocoderMetamodelChildrenForManyWithModelTemplate>>#findObjectIfFoundIfNoneTemplate'>

	^ self gemStoneSessionViewModels
		detect: [ :eachGemStoneSessionViewModels |
			eachGemStoneSessionViewModels gemStoneSession = aSession ]
		ifFound: aFoundBlock
		ifNone: aNoneBlock
]

{ #category : #'api - accessing' }
GtGemStoneSessionsViewModel >> gemStoneSessionViewModels [
	"Return a collection of objects (${class:GtGemStoneSessionViewModel}$) created for each child from the domain model.
	Note: The children are lazily instantiated."
	<return: #Collection of: #GtGemStoneSessionViewModel>
	<childObjectGetter: #session>
	<generatedFrom: #'TGtRobocoderMetamodelChildrenForManyWithModelTemplate>>#childObjectsTemplate'>

	^  gemStoneSessionViewModels ifNil: [ gemStoneSessionViewModels := self createGemStoneSessionViewModels ]
]

{ #category : #'gt-extentions' }
GtGemStoneSessionsViewModel >> gtSessionListViewFor: aView [
	<gtView>
	<generatedFrom: #'GtRobocoderMetamodelPhlowListViewDerive>>#listForManyTemplate'>

	^ aView list
		priority: 5;
		title: 'Session';
		items: [ self gemStoneSessionViewModels ]
]

{ #category : #'api - active sessions' }
GtGemStoneSessionsViewModel >> hasActiveSessions [
	"Return a true if nil is assigned to the receiver, false otherwise"
	<return: #Boolean>
	<modelTester: #activeSessions>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#hasObjectTemplate'>

	^ activeSessions notNil
]

{ #category : #'api - testing' }
GtGemStoneSessionsViewModel >> hasParentGemStoneSessionManagerViewModel [
	"Return true if the parent object is attached"
	<return: #Boolean>
	<parentObjectTester: #sessionManager>
	<generatedFrom: #'TGtRobocoderMetamodelParentAccessorTemplate>>#parentObjectTesterTemplate'>

	^ parentGemStoneSessionManagerViewModel notNil
]

{ #category : #'api - testing' }
GtGemStoneSessionsViewModel >> includesGemStoneSessionViewModels: aGemStoneSessionViewModels [
	"Check and return true if a given child object exists among my children, false otherwise.
	The comparison happens by identity"
	<return: #Boolean>
	<childObjectFinder: #session>
	<generatedFrom: #'TGtRobocoderMetamodelChildrenForManyWithModelTemplate>>#includesObjectTemplate'>

	^ self gemStoneSessionViewModels anySatisfy: [ :eachGemStoneSessionViewModels |
		eachGemStoneSessionViewModels == aGemStoneSessionViewModels ]
]

{ #category : #'api - activated session view model' }
GtGemStoneSessionsViewModel >> notifyActivatedSessionViewModelChanged [
	"Override this notify method to announce changes to the property"
	<propertyChangeNotifier: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#notifyPropertyChangedTemplate'>
	self announce: (GtGemStoneActivatedSessionViewModelChanged new
		activatedSessionViewModel: self activatedSessionViewModel).
]

{ #category : #'api - selected session view model' }
GtGemStoneSessionsViewModel >> notifySelectedSessionViewModelChanged [
	"Override this notify method to announce changes to the property"
	<propertyChangeNotifier: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#notifyPropertyChangedTemplate'>
	self announce: (GtGemStoneSelectedSessionViewModelChanged new
		selectedSessionViewModel: self selectedSessionViewModel).
]

{ #category : #'api - active sessions' }
GtGemStoneSessionsViewModel >> onActiveSessionsChanged [
	"Is sent when a new activeSessions is assigned to the receiver.
	Note: #onActiveSessionsChanged is sent before #subscribeToActiveSessions
	which means that if you perform any operation that triggers an announcement it will be ignored because the receiver
	didn't get a chance to subscribe to any announcement. Override #onPostActiveSessionsChanged if you
	wish to perform an operation that requires an announcement, but keep in mind that this is not the most efficient way"
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onObjectChangedTemplate'>
]

{ #category : #'api - activated session view model' }
GtGemStoneSessionsViewModel >> onNewActivatedSessionViewModelSet: aNewActivatedSessionViewModel [
	"Is sent after a new value of the activatedSessionViewModel is assigned"
	<propertySetHook: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onNewPropertySetHookTemplate'>

	aNewActivatedSessionViewModel notifySessionActivated
]

{ #category : #'api - selected session view model' }
GtGemStoneSessionsViewModel >> onNewSelectedSessionViewModelSet: aNewSelectedSessionViewModel [
	"Is sent after a new value of the selectedSessionViewModel is assigned"
	<propertySetHook: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onNewPropertySetHookTemplate'>

	aNewSelectedSessionViewModel notifySessionSelected
]

{ #category : #'api - active sessions' }
GtGemStoneSessionsViewModel >> onPostActiveSessionsChanged [
	"I am an optional hook method that is sent after #subscribeToActiveSessions.
	I do nothing by default but allow users to perform update operations when a receiver object is already
	subscribed to announcements."
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#onPostObjectChangedTemplate'>
]

{ #category : #'api - activated session view model' }
GtGemStoneSessionsViewModel >> onPreviousActivatedSessionViewModelUnset: aPreviousActivatedSessionViewModel [
	"Is sent after a previous value of the activatedSessionViewModel is de-assigned"
	<propertyUnsetHook: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onPreviousPropertyUnsetHookTemplate'>

	aPreviousActivatedSessionViewModel deactivateChildren.
	aPreviousActivatedSessionViewModel notifySessionDeactivated
]

{ #category : #'api - selected session view model' }
GtGemStoneSessionsViewModel >> onPreviousSelectedSessionViewModelUnset: aPreviousSelectedSessionViewModel [
	"Is sent after a previous value of the selectedSessionViewModel is de-assigned"
	<propertyUnsetHook: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderWithPropertyTraitTemplate>>#onPreviousPropertyUnsetHookTemplate'>

	aPreviousSelectedSessionViewModel deselectChildren.
	aPreviousSelectedSessionViewModel notifySessionDeselected
]

{ #category : #'api - accessing' }
GtGemStoneSessionsViewModel >> parentGemStoneSessionManagerViewModel [
	"Return a parent object which is used to access various state properties,
	for example parent may be responsible for knowing a selected child object.
	In order for the child to know if it is selected, that child should know the parent object."
	<return: #GtGemStoneSessionManagerViewModel>
	<parentObjectGetter: #sessionManager>
	<generatedFrom: #'TGtRobocoderMetamodelParentAccessorTemplate>>#parentObjectGetterTemplate'>

	self
		assert: [ parentGemStoneSessionManagerViewModel notNil ]
		description: [ 'Parent is not assigned!' ].

	^ parentGemStoneSessionManagerViewModel
]

{ #category : #'api - accessing' }
GtGemStoneSessionsViewModel >> parentGemStoneSessionManagerViewModel: aGtGemStoneSessionManagerViewModel [
	"Assign a parent object (${class:GtGemStoneSessionManagerViewModel}$) which is used to access various state properties,
	for example parent may be responsible for knowing a selected child object.
	In order for the child to know if it is selected, that child should know the parent object."
	<parentObjectSetter: #sessionManager>
	<generatedFrom: #'TGtRobocoderMetamodelParentAccessorTemplate>>#parentObjectSetterTemplate'>

	self
		assert: [ aGtGemStoneSessionManagerViewModel notNil ]
		description: [ 'Parent view model must not be nil' ].

	parentGemStoneSessionManagerViewModel := aGtGemStoneSessionManagerViewModel
]

{ #category : #printing }
GtGemStoneSessionsViewModel >> printOn: aStream [
	<generatedFrom: #'GtRobocoderMetamodelPrintDerive>>#printOnTemplate'>
	aStream print: self activeSessions
]

{ #category : #'api - active sessions' }
GtGemStoneSessionsViewModel >> subscribeToActiveSessions [
	"Is sent after a new activeSessions is assigned to the receiver.
	It is required to unsubscribe from the previously subscribed objects by implementing
	#unsubscribeFromActiveSessions if the receiver subscribes to them"
	<modelSubscriber: #activeSessions>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#subscribeToObjectTemplate'>
]

{ #category : #'api - activation' }
GtGemStoneSessionsViewModel >> topMostParentsWithActivationDo: aBlock [
	"Evaluate a given block with each top most parent that has a activation property"
	<propertyTopMostParents: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#topMostParentsWithPropertyDoTemplate'>
	
	aBlock value: self.
]

{ #category : #'api - selection' }
GtGemStoneSessionsViewModel >> topMostParentsWithSelectionDo: aBlock [
	"Evaluate a given block with each top most parent that has a selection property"
	<propertyTopMostParents: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#topMostParentsWithPropertyDoTemplate'>
	
	aBlock value: self.
]

{ #category : #'api - announcer' }
GtGemStoneSessionsViewModel >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"

	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#unsubscribeTemplate'>
	^ announcer ifNotNil: [ :anAnnouncer | anAnnouncer unsubscribe: anObject ]
]

{ #category : #'api - active sessions' }
GtGemStoneSessionsViewModel >> unsubscribeFromActiveSessions [
	"Is sent before a new activeSessions is assigned to the receiver.
	Objects that subscribe to activeSessions are required to implement this method."
	<modelUnsubscriber: #activeSessions>
	<generatedFrom: #'TGtRobocoderWithObjectTraitTemplate>>#unsubscribeFromObjectTemplate'>
]

{ #category : #'api - announcer' }
GtGemStoneSessionsViewModel >> when: anAnnouncementClass do: aBlock [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ])
		when: anAnnouncementClass do: aBlock
]

{ #category : #'api - announcer' }
GtGemStoneSessionsViewModel >> when: anAnnouncementClass do: aBlock for: aSubscriber [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoForTemplate'>
	^ (self when: anAnnouncementClass do: aBlock)
		subscriber: aSubscriber;
		yourself
]

{ #category : #'api - announcer' }
GtGemStoneSessionsViewModel >> when: anAnnouncementClass send: aSelector to: anObject [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenSendToTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ]) weak
		when: anAnnouncementClass send: aSelector to: anObject
]
