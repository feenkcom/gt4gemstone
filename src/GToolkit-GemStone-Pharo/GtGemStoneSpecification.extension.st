Extension { #name : #GtGemStoneSpecification }

{ #category : #'*GToolkit-GemStone-Pharo' }
GtGemStoneSpecification >> gtViewJsonDataFor: aView [
	<gtView>
	
	^ aView textEditor
		title: 'JSON';
		priority: 55;
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		styler: [ JSONParser gtStyler ];
		text: [ (STONJSON toStringPretty: (
			STONJSON fromString: self asJsonForExport)) ];
		actionButtonIcon: BrGlamorousIcons tree 
			action: [ :aButton | 
				aButton phlow 
					spawnObject: (self  asDictionaryForExport asJson) ]
]
