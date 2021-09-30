Class {
	#name : #GtGemStoneSessionManagerViewModel,
	#superclass : #Object,
	#traits : 'TGtWithGemStoneSessionRegistry',
	#classTraits : 'TGtWithGemStoneSessionRegistry classTrait',
	#instVars : [
		'gemStoneSessionsViewModel',
		'announcer'
	],
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #actions }
GtGemStoneSessionManagerViewModel >> addNewConnector [ 

	gemStoneSessionRegistry addNewConnector
]

{ #category : #accessing }
GtGemStoneSessionManagerViewModel >> allConnectors [

	^ gemStoneSessionRegistry allConnectors
]

{ #category : #'api - announcer' }
GtGemStoneSessionManagerViewModel >> announce: anAnnouncement [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#announceTemplate'>
	announcer ifNotNil: [ :anAnnouncer | anAnnouncer announce: anAnnouncement ].
]

{ #category : #accessing }
GtGemStoneSessionManagerViewModel >> connectorNamed: aString [

	^ gemStoneSessionRegistry connectorNamed: aString
]

{ #category : #'private - instance creation' }
GtGemStoneSessionManagerViewModel >> createGemStoneSessionsViewModel [
	"Create a nested child object for a domain child (or children) and return the result"
	<return: #GtGemStoneSessionsViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelChildrenForOneTemplate>>#createChildObjectsTemplate'>
	| childObject |

	childObject := GtGemStoneSessionsViewModel new.
	childObject parentGemStoneSessionManagerViewModel: self.
	childObject activeSessions: self gemStoneSessionRegistry allSessions.
	^ childObject
]

{ #category : #'api - activation' }
GtGemStoneSessionManagerViewModel >> deactivateAllFromTopMostParent [
	"Deactivate any activated child starting from the top most parent"
	<propertyUnsetFromParent: #activatedSessionManagerViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetAllFromTopMostParentTemplate'>
	
	self topMostParentsWithActivationDo: [ :eachParent | eachParent deactivateChildren ]
]

{ #category : #'api - activation' }
GtGemStoneSessionManagerViewModel >> deactivateChildren [
	"Deactivate any activated child"
	<propertyUnsetChildren: #activatedSessionManagerViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetChildrenTemplate'>
	self gemStoneSessionsViewModel deactivateSessionViewModel.
]

{ #category : #'api - selection' }
GtGemStoneSessionManagerViewModel >> deselectAllFromTopMostParent [
	"Deselect any selected child starting from the top most parent"
	<propertyUnsetFromParent: #selectedSessionManagerViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetAllFromTopMostParentTemplate'>
	
	self topMostParentsWithSelectionDo: [ :eachParent | eachParent deselectChildren ]
]

{ #category : #'api - selection' }
GtGemStoneSessionManagerViewModel >> deselectChildren [
	"Deselect any selected child"
	<propertyUnsetChildren: #selectedSessionManagerViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#unsetChildrenTemplate'>
	self gemStoneSessionsViewModel deselectSessionViewModel.
]

{ #category : #'api - accessing' }
GtGemStoneSessionManagerViewModel >> gemStoneSessionsViewModel [
	"Return a composite object (${class:nil}$) created for a collection of children from the domain model.
	Note: The object is lazily instantiated."
	<return: #GtGemStoneSessionsViewModel>
	<childObjectGetter: #sessions>
	<generatedFrom: #'TGtRobocoderMetamodelChildrenForOneTemplate>>#childObjectsTemplate'>

	^ gemStoneSessionsViewModel ifNil: [ gemStoneSessionsViewModel := self createGemStoneSessionsViewModel ]
]

{ #category : #'gt-extentions' }
GtGemStoneSessionManagerViewModel >> gtSessionsListViewFor: aView [
	<gtView>
	<generatedFrom: #'GtRobocoderMetamodelPhlowListViewDerive>>#listForOneTemplate'>

	^ aView list
		priority: 5;
		title: 'Sessions';
		items: [ self gemStoneSessionsViewModel gemStoneSessionViewModels ]
]

{ #category : #printing }
GtGemStoneSessionManagerViewModel >> printOn: aStream [
	<generatedFrom: #'GtRobocoderMetamodelPrintDerive>>#printOnTemplate'>
	aStream print: self gemStoneSessionRegistry
]

{ #category : #accessing }
GtGemStoneSessionManagerViewModel >> sessionNamed: aString [

	^ gemStoneSessionRegistry sessionNamed: aString
]

{ #category : #'api - activation' }
GtGemStoneSessionManagerViewModel >> topMostParentsWithActivationDo: aBlock [
	"Evaluate a given block with each top most parent that has a activation property"
	<propertyTopMostParents: #activatedSessionManagerViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#topMostParentsWithPropertyDoTemplate'>
	
	aBlock value: self.
]

{ #category : #'api - selection' }
GtGemStoneSessionManagerViewModel >> topMostParentsWithSelectionDo: aBlock [
	"Evaluate a given block with each top most parent that has a selection property"
	<propertyTopMostParents: #selectedSessionManagerViewModel>
	<generatedFrom: #'TGtRobocoderMetamodelPropertyForParentTemplate>>#topMostParentsWithPropertyDoTemplate'>
	
	aBlock value: self.
]

{ #category : #'api - announcer' }
GtGemStoneSessionManagerViewModel >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"

	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#unsubscribeTemplate'>
	^ announcer ifNotNil: [ :anAnnouncer | anAnnouncer unsubscribe: anObject ]
]

{ #category : #'api - announcer' }
GtGemStoneSessionManagerViewModel >> when: anAnnouncementClass do: aBlock [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenDoTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ])
		when: anAnnouncementClass do: aBlock
]

{ #category : #'api - announcer' }
GtGemStoneSessionManagerViewModel >> when: anAnnouncementClass send: aSelector to: anObject [
	<generatedFrom: #'TGtRobocoderAnnouncerTemplate>>#whenSendToTemplate'>
	^ (announcer ifNil: [ announcer := Announcer new ]) weak
		when: anAnnouncementClass send: aSelector to: anObject
]
