Extension { #name : #GtGemStoneExtensionMethods }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethods class >> compileAllOnGemStone [
	"Recompile the current GT extension descriptors in the default GemStone session.
	This updates the registry, without applying extensions or committing the session."
	| session script |
	session := GtGemStoneSessionRegistry defaultSession.
	script := String streamContents: [ :stream |
		self extensionSelectors do: [ :selector |
			| method |
			method := self class >> selector.
			stream nextPutAll: (GtGemStoneClassDefinitionTool
				compileScriptForSource: method sourceCode
				protocol: method protocolName
				className: self name
				meta: true
				environmentId: 0).
			stream cr ] ].
	^ session evaluateAndWait: script
]
