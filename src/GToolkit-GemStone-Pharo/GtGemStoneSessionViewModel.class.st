Class {
	#name : #GtGemStoneSessionViewModel,
	#superclass : #Object,
	#traits : 'TGtWithGemStoneSession',
	#classTraits : 'TGtWithGemStoneSession classTrait',
	#instVars : [
		'parentGemStoneSessionsViewModel',
		'announcer'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #'api - activation' }
GtGemStoneSessionViewModel >> activateSession [
	"Just activate a session without changing children"
	<propertySetter: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#setObjectTemplate'>
	
	self hasParentGemStoneSessionsViewModel
		ifTrue: [ self parentGemStoneSessionsViewModel activateSessionViewModel: self ]
]

{ #category : #'api - activation' }
GtGemStoneSessionViewModel >> activateSessionWithoutOtherEntities [
	"Activate a session and deactivate other activated children"

	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#setObjectWithoutOtherEntitiesTemplate'>
	self deactivateAllFromTopMostParent.
	self activateSession
]

{ #category : #'api - actions' }
GtGemStoneSessionViewModel >> allSessionActions [
	^ Array streamContents: [ :aStream |
		self gtActions
			select: [ :eachAction | eachAction target = GtGemStoneSessionActionTarget uniqueInstance ]
			thenDo: [ :eachAction | aStream nextPut: eachAction ] ]
]

{ #category : #'api - announcer' }
GtGemStoneSessionViewModel >> announce: anAnnouncement [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#announceTemplate'>
	announcer ifNotNil: [ :anAnnouncer | anAnnouncer announce: anAnnouncement ].
	"Dispatch anAnnouncement to the parent objects if they are assigned"
	self hasParentGemStoneSessionsViewModel
		ifTrue: [ self parentGemStoneSessionsViewModel announce: anAnnouncement ].
]

{ #category : #'api - activation' }
GtGemStoneSessionViewModel >> beDefaultSession [

	gemStoneSession beDefaultSession.
]

{ #category : #'api - activation' }
GtGemStoneSessionViewModel >> deactivateAllFromTopMostParent [
	"Deactivate any activated child starting from the top most parent"
	<propertyUnsetFromParent: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetAllFromTopMostParentTemplate'>
	
	self topMostParentsWithActivationDo: [ :eachParent | eachParent deactivateChildren ]
]

{ #category : #'api - activation' }
GtGemStoneSessionViewModel >> deactivateChildren [
	"Deactivate any activated child"
	<propertyUnsetChildren: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetChildrenTemplate'>
]

{ #category : #'api - selection' }
GtGemStoneSessionViewModel >> deselectAllFromTopMostParent [
	"Deselect any selected child starting from the top most parent"
	<propertyUnsetFromParent: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetAllFromTopMostParentTemplate'>
	
	self topMostParentsWithSelectionDo: [ :eachParent | eachParent deselectChildren ]
]

{ #category : #'api - selection' }
GtGemStoneSessionViewModel >> deselectChildren [
	"Deselect any selected child"
	<propertyUnsetChildren: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetChildrenTemplate'>
]

{ #category : #'api - actions' }
GtGemStoneSessionViewModel >> gtActivateFor: anAction [
	<gtAction>
	
	^ anAction button
		label: 'Activate';
		icon: BrGlamorousVectorIcons accept;
		action: [ :button | self activateSession ];
		target: GtGemStoneSessionActionTarget uniqueInstance
]

{ #category : #'api - actions' }
GtGemStoneSessionViewModel >> gtBeDefaultFor: anAction [
	<gtAction>
	
	^ anAction button
		label: 'Be Default';
		icon: BrGlamorousVectorIcons greencircle;
		action: [ :button | self beDefaultSession ];
		target: GtGemStoneSessionActionTarget uniqueInstance
]

{ #category : #'api - actions' }
GtGemStoneSessionViewModel >> gtModifyFor: anAction [
	<gtAction>
	
	^ anAction button
		label: 'Edit session';
		icon: BrGlamorousVectorIcons edit;
		action: [ :aButton | aButton phlow spawnObject: self gemStoneSession ];
		target: GtGemStoneSessionActionTarget uniqueInstance
]

{ #category : #'api - activation' }
GtGemStoneSessionViewModel >> hasOtherActivatedEntities [
	"Return true if there are other activated entities that are the children"
	<return: #Boolean>
	<propertyTestOthers: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#hasOtherPropertyTesterTemplate'>

	^ false
]

{ #category : #'api - selection' }
GtGemStoneSessionViewModel >> hasOtherSelectedEntities [
	"Return true if there are other selected entities that are the children"
	<return: #Boolean>
	<propertyTestOthers: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#hasOtherPropertyTesterTemplate'>

	^ false
]

{ #category : #'api - testing' }
GtGemStoneSessionViewModel >> hasParentGemStoneSessionsViewModel [
	"Return true if the parent object is attached"
	<return: #Boolean>
	<parentObjectTester: #sessions>
	<generatedFrom: #'TGtRobocoderMetamodelParentAccessorTemplate>>#parentObjectTesterTemplate'>

	^ parentGemStoneSessionsViewModel notNil
]

{ #category : #'api - activation' }
GtGemStoneSessionViewModel >> isActivatedSession [
	"Return true if this session is activated"
	<return: #Boolean>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#propertyStatusTesterTemplate'>

	^ self parentGemStoneSessionsViewModel hasActivatedSessionViewModel
		and: [ self parentGemStoneSessionsViewModel activatedSessionViewModel == self ]
]

{ #category : #'api - testing' }
GtGemStoneSessionViewModel >> isDefaultSession [

	^ gemStoneSession isDefaultSession
]

{ #category : #'api - activation' }
GtGemStoneSessionViewModel >> isOnlyActivatedSession [
	"Return true if only this session is activated and not any of the children"
	<return: #Boolean>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#onlyPropertyStatusTesterTemplate'>

	^ self isActivatedSession and: [ self hasOtherActivatedEntities not ]
]

{ #category : #'api - selection' }
GtGemStoneSessionViewModel >> isOnlySelectedSession [
	"Return true if only this session is selected and not any of the children"
	<return: #Boolean>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#onlyPropertyStatusTesterTemplate'>

	^ self isSelectedSession and: [ self hasOtherSelectedEntities not ]
]

{ #category : #'api - selection' }
GtGemStoneSessionViewModel >> isSelectedSession [
	"Return true if this session is selected"
	<return: #Boolean>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#propertyStatusTesterTemplate'>

	^ self parentGemStoneSessionsViewModel hasSelectedSessionViewModel
		and: [ self parentGemStoneSessionsViewModel selectedSessionViewModel == self ]
]

{ #category : #'api - accessing' }
GtGemStoneSessionViewModel >> name [
	^ self gemStoneSession name
]

{ #category : #'api - activation' }
GtGemStoneSessionViewModel >> notifySessionActivated [
	<propertySetNotifier: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#notifyPropertySetTemplate'>

	self announce: (GtGemStoneSessionViewModelActivated new gemStoneSessionViewModel: self)
]

{ #category : #'api - activation' }
GtGemStoneSessionViewModel >> notifySessionDeactivated [
	<propertyUnsetNotifier: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#notifyPropertyUnsetTemplate'>

	self announce: (GtGemStoneSessionViewModelDeactivated new gemStoneSessionViewModel: self)
]

{ #category : #'api - selection' }
GtGemStoneSessionViewModel >> notifySessionDeselected [
	<propertyUnsetNotifier: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#notifyPropertyUnsetTemplate'>

	self announce: (GtGemStoneSessionViewModelDeselected new gemStoneSessionViewModel: self)
]

{ #category : #'api - selection' }
GtGemStoneSessionViewModel >> notifySessionSelected [
	<propertySetNotifier: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#notifyPropertySetTemplate'>

	self announce: (GtGemStoneSessionViewModelSelected new gemStoneSessionViewModel: self)
]

{ #category : #'api - accessing' }
GtGemStoneSessionViewModel >> parentGemStoneSessionsViewModel [
	"Return a parent object which is used to access various state properties,
	for example parent may be responsible for knowing a selected child object.
	In order for the child to know if it is selected, that child should know the parent object."
	<return: #GtGemStoneSessionsViewModel>
	<parentObjectGetter: #sessions>
	<generatedFrom: #'TGtRobocoderMetamodelParentAccessorTemplate>>#parentObjectGetterTemplate'>

	self
		assert: [ parentGemStoneSessionsViewModel notNil ]
		description: [ 'Parent is not assigned!' ].

	^ parentGemStoneSessionsViewModel
]

{ #category : #'api - accessing' }
GtGemStoneSessionViewModel >> parentGemStoneSessionsViewModel: aGtGemStoneSessionsViewModel [
	"Assign a parent object (${class:GtGemStoneSessionsViewModel}$) which is used to access various state properties,
	for example parent may be responsible for knowing a selected child object.
	In order for the child to know if it is selected, that child should know the parent object."
	<parentObjectSetter: #sessions>
	<generatedFrom: #'TGtRobocoderMetamodelParentAccessorTemplate>>#parentObjectSetterTemplate'>

	self
		assert: [ aGtGemStoneSessionsViewModel notNil ]
		description: [ 'Parent view model must not be nil' ].

	parentGemStoneSessionsViewModel := aGtGemStoneSessionsViewModel
]

{ #category : #printing }
GtGemStoneSessionViewModel >> printOn: aStream [
	<generatedFrom: #'GtRobocoderMetamodelPrintDerive>>#printOnTemplate'>
	aStream print: self gemStoneSession
]

{ #category : #'api - selection' }
GtGemStoneSessionViewModel >> selectSession [
	"Just select a session without changing children"
	<propertySetter: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#setObjectTemplate'>
	
	self hasParentGemStoneSessionsViewModel
		ifTrue: [ self parentGemStoneSessionsViewModel selectSessionViewModel: self ]
]

{ #category : #'api - selection' }
GtGemStoneSessionViewModel >> selectSessionWithoutOtherEntities [
	"Select a session and deselect other selected children"

	<generatedFrom: #'TGtRobocoderMetamodelPropertyForChildTemplate>>#setObjectWithoutOtherEntitiesTemplate'>
	self deselectAllFromTopMostParent.
	self selectSession
]

{ #category : #'api - accessing' }
GtGemStoneSessionViewModel >> stoneName [
	^ self gemStoneSession stoneName
]

{ #category : #'api - activation' }
GtGemStoneSessionViewModel >> topMostParentsWithActivationDo: aBlock [
	"Evaluate a given block with each top most parent that has a activation property"
	<propertyTopMostParents: #activatedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#topMostParentsWithPropertyDoTemplate'>
	
	| aCurrentParent aParentFound |
	
	aParentFound := false.
	
	aCurrentParent := self.
	(aCurrentParent notNil and: [ aCurrentParent hasParentGemStoneSessionsViewModel ])
		ifFalse: [ aCurrentParent := nil ]
		ifTrue: [ aCurrentParent := aCurrentParent parentGemStoneSessionsViewModel ].
	
	aCurrentParent
		ifNotNil: [
			aParentFound := true.
			aCurrentParent topMostParentsWithActivationDo: aBlock ].
	
	
	"there is no assigned parent, meaning I am the topmost"
	aParentFound
		ifFalse: [ aBlock value: self ].
]

{ #category : #'api - selection' }
GtGemStoneSessionViewModel >> topMostParentsWithSelectionDo: aBlock [
	"Evaluate a given block with each top most parent that has a selection property"
	<propertyTopMostParents: #selectedSessionViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#topMostParentsWithPropertyDoTemplate'>
	
	| aCurrentParent aParentFound |
	
	aParentFound := false.
	
	aCurrentParent := self.
	(aCurrentParent notNil and: [ aCurrentParent hasParentGemStoneSessionsViewModel ])
		ifFalse: [ aCurrentParent := nil ]
		ifTrue: [ aCurrentParent := aCurrentParent parentGemStoneSessionsViewModel ].
	
	aCurrentParent
		ifNotNil: [
			aParentFound := true.
			aCurrentParent topMostParentsWithSelectionDo: aBlock ].
	
	
	"there is no assigned parent, meaning I am the topmost"
	aParentFound
		ifFalse: [ aBlock value: self ].
]

{ #category : #'api - announcer' }
GtGemStoneSessionViewModel >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"

	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#unsubscribeTemplate'>
	^ announcer ifNotNil: [ :anAnnouncer | anAnnouncer unsubscribe: anObject ]
]

{ #category : #'api - accessing' }
GtGemStoneSessionViewModel >> username [
	^ self gemStoneSession username
]

{ #category : #'api - announcer' }
GtGemStoneSessionViewModel >> when: anAnnouncementClass do: aBlock [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ])
		when: anAnnouncementClass do: aBlock
]

{ #category : #'api - announcer' }
GtGemStoneSessionViewModel >> when: anAnnouncementClass do: aBlock for: aSubscriber [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoForTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ])
		when: anAnnouncementClass do: aBlock for: aSubscriber
]

{ #category : #'api - announcer' }
GtGemStoneSessionViewModel >> when: anAnnouncementClass send: aSelector to: anObject [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenSendToTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ]) weak
		when: anAnnouncementClass send: aSelector to: anObject
]
