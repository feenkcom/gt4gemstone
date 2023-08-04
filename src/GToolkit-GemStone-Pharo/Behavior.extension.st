Extension { #name : #Behavior }

{ #category : #'*GToolkit-GemStone-Pharo' }
Behavior >> gtGsClassEditorButtonFor: anAction [
	<gtClassAction>

	(GtGemStoneSessionRegistry hasUniqueInstance not or:
		[ GtGemStoneSessionRegistry default defaultSession isNil ])
			ifTrue: [ ^ anAction noAction ].
	^ anAction button
		label: 'GS';
		tooltip: 'Edit & synchronize class definitions';
		priority: 10;
		icon: BrGlamorousVectorIcons edit;
		id: GtGemStoneClassDefinitionToolButtonId;
		action: [ :aButton | 
			aButton phlow spawnObject: 
				(GtGemStoneClassDefinitionTool targetClassName: self name) ]
]
