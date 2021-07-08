Class {
	#name : #BaselineOfGtGemstoneServer,
	#superclass : #BaselineOf,
	#category : #BaselineOfGtGemstoneServer
}

{ #category : #baselines }
BaselineOfGtGemstoneServer >> baseline: spec [
	<baseline>

	spec for: #common do: [ 
		spec
			baseline: 'RemoteServiceReplication'
			with: [ spec repository: 'github://GemTalk/RemoteServiceReplication:main/src' ].
		spec 
			package: 'GToolkit-GemStone' with:
				[ spec requires: #( 'RemoteServiceReplication' ) ];
			package: 'GToolkit-GemStone-GemStone' with:
				[ spec requires: #( 'GToolkit-GemStone' ) ] ].
]
