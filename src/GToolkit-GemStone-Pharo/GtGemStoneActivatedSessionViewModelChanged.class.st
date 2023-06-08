Class {
	#name : #GtGemStoneActivatedSessionViewModelChanged,
	#superclass : #Announcement,
	#instVars : [
		'activatedSessionViewModel'
	],
	#category : #'GToolkit-GemStone-Pharo-Events'
}

{ #category : #generated }
GtGemStoneActivatedSessionViewModelChanged >> activatedSessionViewModel [
	<objectGetter: #session>
	<generatedFrom: #'GtRobocoderMetamodelAnnouncementTemplate>>#objectGetterTemplate'>

	^ activatedSessionViewModel
]

{ #category : #generated }
GtGemStoneActivatedSessionViewModelChanged >> activatedSessionViewModel: aActivatedSessionViewModel [
	<objectSetter: #session>
	<generatedFrom: #'GtRobocoderMetamodelAnnouncementTemplate>>#objectSetterTemplate'>

	activatedSessionViewModel := aActivatedSessionViewModel
]
