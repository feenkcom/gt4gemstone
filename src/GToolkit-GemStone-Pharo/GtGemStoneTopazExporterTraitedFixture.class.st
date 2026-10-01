"
Fixture class used to demonstrate flattened trait export.
"
Class {
	#name : #GtGemStoneTopazExporterTraitedFixture,
	#superclass : #Object,
	#traits : 'TGtGemStoneTopazExporterFixture',
	#classTraits : 'TGtGemStoneTopazExporterFixture classTrait',
	#instVars : [
		'localValue'
	],
	#classInstVars : [
		'localClassValue'
	],
	#category : #'GToolkit-GemStone-Pharo-Examples'
}

{ #category : #accessing }
GtGemStoneTopazExporterTraitedFixture >> localGreeting [
	^ 'local'
]
