Extension { #name : #GtGemStoneExtensionMethods }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethods class >> applyOnGemStone [
	"Apply the extensions as they exist on GemStone."
	| session |
	
	session := GtGemStoneSessionRegistry defaultSession.
	^ session evaluateBlockAndWait: [ GtGemStoneExtensionMethods apply ].
]

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

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethods class >> compileAndApplyOnGemStone [
	"Apply the extensions as they exist on GemStone."

	self compileAllOnGemStone.
	self applyOnGemStone.
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethods class >> newFromClass: className selector: selector meta: aBoolean [
	"Generate a new extension method based on the existing method in the current session."
	
	
^ self 
	newFromClass: className 
	selector: selector 
	meta: aBoolean
	session: GtGemStoneSessionRegistry defaultSession
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethods class >> newFromClass: className selector: selector meta: aBoolean session: aGtGemStoneSession [
	^ (GtGemStoneExtensionMethod
			newFromClass: className
			selector: selector
			meta: aBoolean
			session: aGtGemStoneSession) compileExtensionIn: self class
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethods class >> newFromLocalClass: className selector: selector meta: aBoolean [
	^ (GtGemStoneExtensionMethod
			newFromLocalClass: className
			selector: selector
			meta: aBoolean) compileExtensionIn: self class
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethods class >> overwriteFromLocalClass: className selector: selector meta: aBoolean [
	^ (GtGemStoneExtensionMethod
			overwriteFromLocalClass: className
			selector: selector
			meta: aBoolean) compileExtensionIn: self class
]

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneExtensionMethods class >> overwriteFromLocalClass: className selector: selector meta: aBoolean session: aGtGemStoneSession [
	^ (GtGemStoneExtensionMethod
			overwriteFromLocalClass: className
			selector: selector
			meta: aBoolean
			session: aGtGemStoneSession) compileExtensionIn: self class
]
