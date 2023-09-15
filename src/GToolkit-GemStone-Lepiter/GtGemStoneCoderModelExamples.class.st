"
LeGemStoneVarNodeVisitorExamples demonstrates the variable categorisation required to set the bindings and temporary variable declarations when passing scripts to GemStone.
"
Class {
	#name : #GtGemStoneCoderModelExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Lepiter-Examples'
}

{ #category : #examples }
GtGemStoneCoderModelExamples >> simpleExpression [
	<gtExample>
	| source coderModel |

	source := '4+3'.
	coderModel := GtGemStoneCoderModel new.
	coderModel sourceCode: (GtCoderExplicitSourceCode new source: source).
	coderModel updateRemoteFrom: source.

	self assert: coderModel remoteScript withUnixLineEndings equals: 
'| snippetResult |
snippetResult := 4+3.
(snippetResult class == GtRsrProxyServiceServer or:
				[ snippetResult isNumber or:
				[ snippetResult class == Boolean ] ]) ifFalse: [ snippetResult := GtRsrProxyServiceServer object: snippetResult ].
{ #snippetResult -> snippetResult. } asDictionary'.
	self assert: coderModel remoteBindings size equals: 0.

]

{ #category : #examples }
GtGemStoneCoderModelExamples >> simpleExpressionWithGlobal [
	<gtExample>
	| source coderModel |

	source := 
'g := 4.
g + 3'.
	coderModel := GtGemStoneCoderModel new.
	coderModel sourceCode: (GtCoderExplicitSourceCode new source: source).
	coderModel updateRemoteFrom: source.

	self assert: coderModel remoteScript withUnixLineEndings equals: 
'| g snippetResult |
g := 4.
snippetResult := g + 3.
(snippetResult class == GtRsrProxyServiceServer or:
				[ snippetResult isNumber or:
				[ snippetResult class == Boolean ] ]) ifFalse: [ snippetResult := GtRsrProxyServiceServer object: snippetResult ].
{ #g -> g. #snippetResult -> snippetResult. } asDictionary'.
	self assert: coderModel remoteBindings size equals: 0.

]

{ #category : #examples }
GtGemStoneCoderModelExamples >> simpleExpressionWithModifiedGlobal [
	<gtExample>
	| source coderModel pharoBindings |

	source := 
'answer := inputVariable + 2.
inputVariable := ''Used''.
answer'.
	coderModel := GtGemStoneCoderModel new.
	coderModel sourceCode: (GtCoderExplicitSourceCode new source: source).
	pharoBindings := GtLocalVariablesBindings new.
	pharoBindings localAt: #inputVariable put: 40.
	coderModel pharoBindings: pharoBindings.
	coderModel updateRemoteFrom: source.

	self assert: coderModel remoteScript withUnixLineEndings equals: 
'| answer snippetResult |
answer := inputVariable + 2.
inputVariable := ''Used''.
snippetResult := answer.
(snippetResult class == GtRsrProxyServiceServer or:
				[ snippetResult isNumber or:
				[ snippetResult class == Boolean ] ]) ifFalse: [ snippetResult := GtRsrProxyServiceServer object: snippetResult ].
{ #inputVariable -> inputVariable. #answer -> answer. #snippetResult -> snippetResult. } asDictionary'.
	self assert: coderModel remoteBindings size equals: 1.
	self assert: (coderModel remoteBindings at: #inputVariable) equals: 40.
	^ coderModel

]

{ #category : #examples }
GtGemStoneCoderModelExamples >> simpleExpressionWithTemps [
	<gtExample>
	| source coderModel |

	source := 
'| a |
a := 4.
a + 3'.
	coderModel := GtGemStoneCoderModel new.
	coderModel sourceCode: (GtCoderExplicitSourceCode new source: source).
	coderModel updateRemoteFrom: source.

	self assert: coderModel remoteScript withUnixLineEndings equals: 
'| snippetResult  a |
a := 4.
snippetResult := a + 3.
(snippetResult class == GtRsrProxyServiceServer or:
				[ snippetResult isNumber or:
				[ snippetResult class == Boolean ] ]) ifFalse: [ snippetResult := GtRsrProxyServiceServer object: snippetResult ].
{ #snippetResult -> snippetResult. } asDictionary'.
	self assert: coderModel remoteBindings size equals: 0.

]
