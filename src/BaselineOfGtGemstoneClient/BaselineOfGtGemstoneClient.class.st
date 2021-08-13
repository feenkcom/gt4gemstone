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
			baseline: 'RemoteServiceReplicationForGlamorousToolkit'
			with: [ spec repository: 'github://feenkcom/RemoteServiceReplication:main/src' ].
		spec
			baseline: 'SparkleFFIForGlamorousToolkit'
			with: [ spec repository: 'github://feenkcom/SparkleFFI:main/src' ].
		spec 
			baseline: 'GToolkitRemote' 
			with: [ spec repository: 'github://feenkcom/gtoolkit-remote:main/src' ].
		spec 
			package: 'GToolkit-GemStone' with:
				[ spec requires: #( 'SparkleFFI' 'RemoteServiceReplication' ) ];
			package: 'GToolkit-GemStone-Pharo' with:
				[ spec requires: #( 'GToolkit-GemStone' 'GToolkitRemote' ) ];
			package: 'GToolkit-GemStone-Lepiter' with:
				[ spec requires: #( 'GToolkit-GemStone-Pharo' ) ];
			package: 'GToolkit-RemoteExamples-GemStone' with:
				[  spec requires: #( 'GToolkit-GemStone-Pharo' ) ] ].
]
