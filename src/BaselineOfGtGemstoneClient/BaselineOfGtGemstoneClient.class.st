Class {
	#name : #BaselineOfGtGemstoneClient,
	#superclass : #BaselineOf,
	#category : #BaselineOfGtGemstoneClient
}

{ #category : #baseline }
BaselineOfGtGemstoneClient >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'RemoteServiceReplicationForGlamorousToolkit' with: [
				spec repository: 'github://feenkcom/RemoteServiceReplication:034dc17d1232c173efa37a65a24dd01adbbedb0e/src' ].
		spec
			baseline: 'SparkleFFIForGlamorousToolkit' with: [
				spec repository: 'github://feenkcom/SparkleFFI:b4802fbc07c7a74ba4c568d03e336cc4a68ffbd4/src' ].
		spec
			baseline: 'GToolkitRemote' with: [
				spec repository: 'github://feenkcom/gtoolkit-remote:v0.8.788/src' ].
		spec
			baseline: 'LepiterEngineCore' with: [
				spec repository: 'github://feenkcom/lepiter:v0.6.524/src' ].

		spec package: 'GToolkit-GemStone' with: [
			spec requires: #('SparkleFFIForGlamorousToolkit' 'RemoteServiceReplicationForGlamorousToolkit') ].
		spec package: 'GToolkit-GemStone-Pharo' with: [
			spec requires: #('GToolkit-GemStone' 'GToolkitRemote') ].
		spec package: 'GToolkit-GemStone-BareProxy-Pharo' with: [
			spec requires: #('GToolkit-GemStone-Pharo') ].
		spec package: 'GToolkit-GemStone-Lepiter' with: [
			spec requires: #('GToolkit-GemStone-Pharo' 'LepiterEngineCore') ].
		spec package: 'GToolkit-RemoteExamples-GemStone' with: [
			spec requires: #('GToolkit-GemStone-Pharo') ].
	]
]
