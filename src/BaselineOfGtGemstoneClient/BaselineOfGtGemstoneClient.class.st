Class {
	#name : #BaselineOfGtGemstoneClient,
	#superclass : #BaselineOf,
	#category : #BaselineOfGtGemstoneClient
}

{ #category : #baseline }
BaselineOfGtGemstoneClient >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec postLoadDoIt: #'postLoadSetup:'.
		spec
			baseline: 'RemoteServiceReplicationForGlamorousToolkit' with: [
				spec repository: 'github://feenkcom/RemoteServiceReplication:1cb09faf8091f578cf61b46d50527a225b062d17/src' ].
		spec
			baseline: 'SparkleFFIForGlamorousToolkit' with: [
				spec repository: 'github://feenkcom/SparkleFFI:3fb14d2e25fa9fa7608df27fae362d27332b620d/src' ].
		spec
			baseline: 'GToolkitRemote' with: [
				spec repository: 'github://feenkcom/gtoolkit-remote:v0.8.1326/src' ].
		spec
			baseline: 'LepiterEngineCore' with: [
				spec repository: 'github://feenkcom/lepiter:v0.6.1695/src' ].

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

{ #category : #'post load' }
BaselineOfGtGemstoneClient >> postLoadSetup: spec [
	"Register the GemStone debugger"

	GtGemStoneDebuggerElement register.
]
