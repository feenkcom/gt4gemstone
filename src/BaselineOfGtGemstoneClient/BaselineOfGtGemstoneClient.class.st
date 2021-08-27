Class {
	#name : 'BaselineOfGtGemstoneClient',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfGtGemstoneClient'
}

{ #category : 'baseline' }
BaselineOfGtGemstoneClient >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'RemoteServiceReplicationForGlamorousToolkit' with: [
				spec repository: 'github://feenkcom/RemoteServiceReplication:cf13ae83485021c731edc41f67e10cab5958c1e6/src' ].
		spec
			baseline: 'SparkleFFIForGlamorousToolkit' with: [
				spec repository: 'github://feenkcom/SparkleFFI:b4802fbc07c7a74ba4c568d03e336cc4a68ffbd4/src' ].
		spec
			baseline: 'GToolkitRemote' with: [
				spec repository: 'github://feenkcom/gtoolkit-remote:v0.8.558/src' ].
		spec
			baseline: 'LepiterEngineCore' with: [
				spec repository: 'github://feenkcom/lepiter:v0.6.129/src' ].

		spec package: 'GToolkit-GemStone' with: [
			spec requires: #('SparkleFFIForGlamorousToolkit' 'RemoteServiceReplicationForGlamorousToolkit') ].
		spec package: 'GToolkit-GemStone-Pharo' with: [
			spec requires: #('GToolkit-GemStone' 'GToolkitRemote') ].
		spec package: 'GToolkit-GemStone-Lepiter' with: [
			spec requires: #('GToolkit-GemStone-Pharo' 'LepiterEngineCore') ].
		spec package: 'GToolkit-RemoteExamples-GemStone' with: [
			spec requires: #('GToolkit-GemStone-Pharo') ].
	]
]
