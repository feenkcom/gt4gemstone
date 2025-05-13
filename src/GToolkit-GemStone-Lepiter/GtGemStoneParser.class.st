Class {
	#name : #GtGemStoneParser,
	#superclass : #GtPharoParser,
	#category : #'GToolkit-GemStone-Lepiter-Parser'
}

{ #category : #examples }
GtGemStoneParser class >> extraPeriodsThrowErrorsExample [
	<gtExample>
	^ #(#('.3 + 4' 1) #('|a|.3 + 4. 4 + 3' 4) #('3 + 4..3' 7) #('3 + 4..' 7) #('3 + 4.' nil) #('[] value. [:e | ] value: 2' nil))
		collect: [ :each | 
			[ | value |
			value := self
					parse: each first
					startingAt: self startingStateForMethodSequence.
			self assert: each last isNil.
			value ]
				on: SmaCCParserError
				do: [ :ex | 
					self assert: ex parser currentToken startPosition equals: each last.
					ex return: ex parser ] ]
]

{ #category : #examples }
GtGemStoneParser class >> pathNameExample [
	<gtExample>
	| ast block body |
	ast := self
			parse: '[:each | each.name.last.]'
			startingAt: self startingStateForMethodSequence.
	self assert: ast statements size equals: 1.
	block := ast statements first.
	self assert: block isBlock.
	body := block body.
	self assert: body statements size equals: 1.
	self assert: body statements first class equals: GtPharoGSPathNode.
	self assert: body statements first name value equals: 'each.name.last'.
	^ ast
]

{ #category : #private }
GtGemStoneParser >> defaultScope [
	^ #gs
]

{ #category : #accessing }
GtGemStoneParser >> parse [
	| result |
	result := super parse.
	((result isKindOf: SmaCCParseNode)
		and: [ errorHandler isKindOf: SmaCCNoErrorHandler ])
		ifTrue: [ result
				withAllNodesOfType: GtPharoSequenceNode
				do: [ :each | self validatePeriodsAsSeparatorsIn: each ] ].
	^ result
]

{ #category : #'initialize-release' }
GtGemStoneParser >> scanner: aScanner [
	super scanner: aScanner.
	(aScanner notNil and: [ aScanner scope = #default ])
		ifTrue: [ aScanner scope: self defaultScope ]
]

{ #category : #private }
GtGemStoneParser >> validatePeriodsAsSeparatorsIn: aSequenceNode [
	(aSequenceNode periods isEmpty
		or: [ aSequenceNode periods size < aSequenceNode statements size ])
		ifTrue: [ ^ self ].
	(aSequenceNode periods size = aSequenceNode statements size
		and: [ aSequenceNode periods last startPosition
				> aSequenceNode statements last stopPosition ]) ifTrue: [ ^ self ].
	1
		to: (aSequenceNode periods size min: aSequenceNode statements size)
		do: [ :i | 
			(aSequenceNode periods at: i) stopPosition
				< (aSequenceNode statements at: i) startPosition
				ifTrue: [ currentToken := aSequenceNode periods at: i.
					^ self reportError: 0 ] ].
	currentToken := aSequenceNode periods at: aSequenceNode statements size + 1.
	^ self reportError: 0
]
