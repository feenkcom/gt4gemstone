Class {
	#name : #GtGemStoneSelectedSessionViewModelChanged,
	#superclass : #Announcement,
	#instVars : [
		'selectedSessionViewModel'
	],
	#category : #'GToolkit-GemStone-Pharo-Events'
}

{ #category : #generated }
GtGemStoneSelectedSessionViewModelChanged >> selectedSessionViewModel [
	<objectGetter: #session>
	<generatedFrom: #'GtRobocoderMetamodelAnnouncementTemplate>>#objectGetterTemplate'>

	^ selectedSessionViewModel
]

{ #category : #generated }
GtGemStoneSelectedSessionViewModelChanged >> selectedSessionViewModel: aSelectedSessionViewModel [
	<objectSetter: #session>
	<generatedFrom: #'GtRobocoderMetamodelAnnouncementTemplate>>#objectSetterTemplate'>

	selectedSessionViewModel := aSelectedSessionViewModel
]
