Class {
	#name : 'BaselineOfGtGemstoneClient',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGtGemstoneClient'
}

{ #category : 'baselines' }
BaselineOfGtGemstoneClient >> baseline: spec [
	<baseline>

	spec for: #common do: [ 
		spec
			baseline: 'RemoteServiceReplication'
			with: [ spec repository: 'github://GemTalk/RemoteServiceReplication:main/src' ].
		spec
			baseline: 'SparkleFFI'
			with: [ spec repository: 'github://feenkcom/SparkleFFI:main/src' ].
		spec 
			package: 'GToolkit-GemStone' with:
				[ spec requires: #( 'SparkleFFI' 'RemoteServiceReplication' ) ];
			package: 'GToolkit-GemStone-Pharo' with:
				[ spec requires: #( 'GToolkit-GemStone' ) ];
			package: 'GToolkit-GemStone-Lepiter' with:
				[ spec requires: #( 'GToolkit-GemStone-Pharo' ) ];
			package: 'GToolkit-RemoteExamples-GemStone' with:
				[  spec requires: #( 'GToolkit-GemStone-Pharo' ) ] ].
]
