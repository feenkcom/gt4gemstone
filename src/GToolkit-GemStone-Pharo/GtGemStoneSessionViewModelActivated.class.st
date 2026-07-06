Class {
	#name : #GtGemStoneSessionViewModelActivated,
	#superclass : #Announcement,
	#instVars : [
		'gemStoneSessionViewModel'
	],
	#category : #'GToolkit-GemStone-Pharo-Events'
}

{ #category : #generated }
GtGemStoneSessionViewModelActivated >> gemStoneSessionViewModel [
	<objectGetter: #session>
	<generatedFrom: #'GtRobocoderMetamodelAnnouncementTemplate>>#objectGetterTemplate'>

	^ gemStoneSessionViewModel
]

{ #category : #generated }
GtGemStoneSessionViewModelActivated >> gemStoneSessionViewModel: aGemStoneSessionViewModel [
	<objectSetter: #session>
	<generatedFrom: #'GtRobocoderMetamodelAnnouncementTemplate>>#objectSetterTemplate'>

	gemStoneSessionViewModel := aGemStoneSessionViewModel
]
