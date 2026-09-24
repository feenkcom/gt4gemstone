Extension { #name : #Set }

{ #category : #'*GToolkit-GemStone-Pharo' }
Set >> intersection: aCollection [
	"Answer the set theoretic intersection of two collections.
	Optimized version for Sets where no intermediate Set is necessary"

	"(#(1 2 3 4) asSet intersection: #(3 4 5) asSet) >>> #(3 4) asSet"

	"(#(1 2 3 4) asSet intersection: #() asSet) >>> Set new"

	"( #() asSet intersection: #(1 2 3 4) asSet) >>> Set new"
	<gsCode:
'	| outputSet |
	outputSet := self class new.
	aCollection do: [ :each | (self includes: each) ifTrue: [ outputSet add: each ] ].
	^ outputSet'>
	| outputSet |
	outputSet := self class new.
	aCollection do: [ :each | (self includes: each) ifTrue: [ outputSet add: each ] ].
	^ outputSet
]
