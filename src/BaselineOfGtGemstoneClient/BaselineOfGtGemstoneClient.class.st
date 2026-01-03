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
				spec repository: 'github://feenkcom/RemoteServiceReplication:5a53d04cb91c4769269a304c7be946477dad5ccf/src' ].
		spec
			baseline: 'PharoGemStoneFFI' with: [
				spec repository: 'github://gemtalk/PharoGemStoneFFI:tag_v1.1/src' ].
		spec
			baseline: 'GToolkitRemote' with: [
				spec repository: 'github://feenkcom/gtoolkit-remote:v0.9.32/src' ].
		spec
			baseline: 'LepiterEngineCore' with: [
				spec repository: 'github://feenkcom/lepiter:v0.7.65/src' ].
		spec
			baseline: 'GToolkitWireEncoding' with: [
				spec repository: 'github://feenkcom/gtoolkit-wireencoding:v0.6.15/src' ].

		spec package: 'GToolkit-GemStone-Pharo-BeaconLogging'.
		spec package: 'GToolkit-GemStone' with: [
			spec requires: #(#PharoGemStoneFFI #RemoteServiceReplicationForGlamorousToolkit) ].
		spec package: 'GToolkit-GemStone-Pharo' with: [
			spec requires: #(#'GToolkit-GemStone' #GToolkitRemote #'GToolkit-GemStone-Pharo-BeaconLogging' #GToolkitWireEncoding) ].
		spec package: 'GToolkit-GemStone-BareProxy-Pharo' with: [
			spec requires: #(#'GToolkit-GemStone-Pharo') ].
		spec package: 'GToolkit-GemStone-Lepiter' with: [
			spec requires: #(#'GToolkit-GemStone-Pharo' #LepiterEngineCore) ].
		spec package: 'GToolkit-GemStone-Transcript' with: [
			spec requires: #(#'GToolkit-GemStone') ].
		spec package: 'GToolkit-RemoteExamples-GemStone' with: [
			spec requires: #(#'GToolkit-GemStone-Pharo') ].
	]
]

{ #category : #'post load' }
BaselineOfGtGemstoneClient >> postLoadSetup: spec [
	"Register the GemStone debugger"

	"GtGemStoneDebuggerElement register."
	GtGemStoneExpandableDebuggerElement register.
]
