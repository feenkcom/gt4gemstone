Class {
	#name : #BaselineOfGtGemstoneClient,
	#superclass : #BaselineOf,
	#category : #BaselineOfGtGemstoneClient
}

{ #category : #baselines }
BaselineOfGtGemstoneClient >> baseline: spec [
	<baseline>

	spec for: #common do: [ 
		spec postLoadDoIt: #'postLoadSetup:'.
		spec
			baseline: 'RemoteServiceReplicationForGlamorousToolkit'
			with: [ spec repository: 'github://feenkcom/RemoteServiceReplication:martin-136PortRange/src' ].
		spec
			baseline: 'SparkleFFIForGlamorousToolkit'
			with: [ spec repository: 'github://feenkcom/SparkleFFI:main/src' ].
		spec 
			baseline: 'GToolkitRemote' 
			with: [ spec repository: 'github://feenkcom/gtoolkit-remote:main/src' ].
		spec
			baseline: 'LepiterEngineCore'
			with: [ spec repository: 'github://feenkcom/lepiter:main/src' ].
		spec 
			package: 'GToolkit-GemStone-Pharo-BeaconLogging';
			package: 'GToolkit-GemStone' with:
				[ spec requires: #( 'SparkleFFIForGlamorousToolkit' 'RemoteServiceReplicationForGlamorousToolkit' ) ];
			package: 'GToolkit-GemStone-Pharo' with:
				[ spec requires: #( 'GToolkit-GemStone' 'GToolkitRemote' 'GToolkit-GemStone-Pharo-BeaconLogging') ];
			package: 'GToolkit-GemStone-BareProxy-Pharo' with:
				[ spec requires: #( 'GToolkit-GemStone-Pharo') ];
			package: 'GToolkit-GemStone-Lepiter' with:
				[ spec requires: #( 'GToolkit-GemStone-Pharo' 'LepiterEngineCore') ];
			package: 'GToolkit-RemoteExamples-GemStone' with:
				[  spec requires: #( 'GToolkit-GemStone-Pharo' ) ] ].
]

{ #category : #'post load' }
BaselineOfGtGemstoneClient >> postLoadSetup: spec [
	"Register the GemStone debugger"

	"GtGemStoneDebuggerElement register."
	GtGemStoneExpandableDebuggerElement register.
]
