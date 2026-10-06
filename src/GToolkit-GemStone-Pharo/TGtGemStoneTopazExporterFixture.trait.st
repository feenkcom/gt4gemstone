"
Fixture trait used by the Topaz exporter examples.
"
Trait {
	#name : #TGtGemStoneTopazExporterFixture,
	#instVars : [
		'traitValue'
	],
	#classInstVars : [
		'traitClassSlot'
	],
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #accessing }
TGtGemStoneTopazExporterFixture >> traitGreeting [
	^ 'from trait'
]

{ #category : #accessing }
TGtGemStoneTopazExporterFixture >> traitValue [
	^ traitValue
]
