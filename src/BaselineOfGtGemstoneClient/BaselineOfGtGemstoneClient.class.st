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
			package: 'GToolkit-GemStone' with:
				[ spec requires: #( 'RemoteServiceReplication' ) ];
			package: 'GToolkit-GemStone-Pharo' with:
				[ spec requires: #( 'GToolkit-GemStone' ) ];
			package: 'GToolkit-GemStone-Lepiter' with:
				[ spec requires: #( 'GToolkit-GemStone-Pharo' ) ] ].
]
