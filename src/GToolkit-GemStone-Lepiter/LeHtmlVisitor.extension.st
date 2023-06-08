Extension { #name : #LeHtmlVisitor }

{ #category : #'*GToolkit-GemStone-Lepiter' }
LeHtmlVisitor >> visitGemStoneSnippet:  aLeGemStoneSnippet [

	context html
		tag: #div
		attributes: #('class' 'snippet textual-snippet code-snippet gemstone-snippet')
		do: [
			context html
				tag: #pre
				attributes: #('class' 'no_bottom_margin')
				with: aLeGemStoneSnippet code ].
	^ self visitContent: aLeGemStoneSnippet
]
