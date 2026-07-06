Class {
	#name : #GtGemStoneSessionViewModelDeactivated,
	#superclass : #Announcement,
	#instVars : [
		'gemStoneSessionViewModel'
	],
	#category : #'GToolkit-GemStone-Pharo-Events'
}

{ #category : #generated }
GtGemStoneSessionViewModelDeactivated >> gemStoneSessionViewModel [
	<objectGetter: #session>
	<generatedFrom: #'GtRobocoderMetamodelAnnouncementTemplate>>#objectGetterTemplate'>

	^ gemStoneSessionViewModel
]

{ #category : #generated }
GtGemStoneSessionViewModelDeactivated >> gemStoneSessionViewModel: aGemStoneSessionViewModel [
	<objectSetter: #session>
	<generatedFrom: #'GtRobocoderMetamodelAnnouncementTemplate>>#objectSetterTemplate'>

	gemStoneSessionViewModel := aGemStoneSessionViewModel
]
