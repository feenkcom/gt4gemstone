"
LeGemStoneVarNodeVisitorExamples demonstrates the variable categorisation required to set the bindings and temporary variable declarations when passing scripts to GemStone.
"
Class {
	#name : #GtGemStoneSnippetRemoteExecutionBuilderExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Lepiter-Examples'
}

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> complexExpression_noBindings [
	<gtExample>
	| source pharoBindings executionBuilder remoteBindings |

	source := 
'| x |
f := 1.
a + b + e.
a := 1.'.
	pharoBindings := GtLocalVariablesBindings new.
	
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: pharoBindings;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames sorted 
		equals: #(f).
	self 
		assert: executionBuilder requiredVariableNames sorted
		equals: #(#a #b #e).
		
	self 
		assert: executionBuilder undeclaredVariableNames sorted 
		equals: #(#a #b #e #f).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#f).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a #b #e).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| f snippetResult  x |
f := 1.
a + b + e.
snippetResult := a := 1.
({ #f -> f. #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> complexExpression_withBindings [
	<gtExample>
	| source pharoBindings executionBuilder remoteBindings |

	source := 
'| x |
f := 1.
a + b + e.
a := 1.'.
	pharoBindings := GtLocalVariablesBindings new.
	pharoBindings localAt: #a put: 40.
	pharoBindings localAt: #b put: 41.
	pharoBindings localAt: #e put: 42.
	
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: pharoBindings;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames sorted equals: #(#a #b #e). 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(f).
	self 
		assert: executionBuilder requiredVariableNames sorted
		equals: #(#a #b #e).
		
	self 
		assert: executionBuilder undeclaredVariableNames sorted 
		equals: #(#a #b #e #f).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#f).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a #b #e).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| f snippetResult  x |
f := 1.
a + b + e.
snippetResult := a := 1.
({ #f -> f. #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> complexExpression_withBindings_allClassSlots [
	<gtExample>
	| source pharoBindings executionBuilder remoteBindings |

	source := 
'| x |
f := 1.
a + b + e.
a := 1.'.
	pharoBindings := GtLocalVariablesBindings new.
	
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: pharoBindings;
		classSlotNames: #(f a b e);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames sorted equals: #(). 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder requiredVariableNames sorted
		equals: #(#a #b #e).
	self 
		assert: executionBuilder variableNamesToReturn asArray
		equals: #().
		
	self 
		assert: executionBuilder undeclaredVariableNames sorted 
		equals: #(#a #b #e #f).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#f).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a #b #e).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult  x |
f := 1.
a + b + e.
snippetResult := a := 1.
({ #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> complexExpression_withBindings_forAccessesFirst [
	<gtExample>
	| source pharoBindings executionBuilder remoteBindings |

	source := 
'| x |
f := 1.
a + b + e.
a := 1.'.
	pharoBindings := GtLocalVariablesBindings new.
	pharoBindings localAt: #a put: 40.
	pharoBindings localAt: #b put: 41.
	pharoBindings localAt: #e put: 42.
	
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: pharoBindings;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames sorted equals: #(#a #b #e). 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(f).
	self 
		assert: executionBuilder requiredVariableNames sorted
		equals: #(#a #b #e).
		
	self 
		assert: executionBuilder undeclaredVariableNames sorted 
		equals: #(#a #b #e #f).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#f).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a #b #e).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| f snippetResult  x |
f := 1.
a + b + e.
snippetResult := a := 1.
({ #f -> f. #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> complexExpression_withBindings_forOnlyAccessed [
	<gtExample>
	| source pharoBindings executionBuilder remoteBindings |

	source := 
'| x |
f := 1.
a + b + e.
a := 1.'.
	pharoBindings := GtLocalVariablesBindings new.
	pharoBindings localAt: #b put: 41.
	pharoBindings localAt: #e put: 42.
	
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: pharoBindings;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames sorted equals: #(#b #e). 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames sorted 
		equals: #(f).
	self 
		assert: executionBuilder requiredVariableNames sorted
		equals: #(#a #b #e).
		
	self 
		assert: executionBuilder undeclaredVariableNames sorted 
		equals: #(#a #b #e #f).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#f).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a #b #e).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| f snippetResult  x |
f := 1.
a + b + e.
snippetResult := a := 1.
({ #f -> f. #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> complexExpression_withBindings_forWrittenFirst [
	<gtExample>
	| source pharoBindings executionBuilder remoteBindings |

	source := 
'| x |
f := 1.
a + b + e.
a := 1.'.
	pharoBindings := GtLocalVariablesBindings new.
	pharoBindings localAt: #a put: 40.
	pharoBindings localAt: #b put: 41.
	pharoBindings localAt: #e put: 42.
	pharoBindings localAt: #f put: 43.
	
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: pharoBindings;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames sorted equals: #(#a #b #e). 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(f).
	self 
		assert: executionBuilder requiredVariableNames sorted
		equals: #(#a #b #e).
		
	self 
		assert: executionBuilder undeclaredVariableNames sorted 
		equals: #(#a #b #e #f).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#f).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a #b #e).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| f snippetResult  x |
f := 1.
a + b + e.
snippetResult := a := 1.
({ #f -> f. #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> complexExpression_withBindings_forWrittenFirst_classSlotIsWrittenFirst [
	<gtExample>
	| source pharoBindings executionBuilder remoteBindings |

	source := 
'| x |
f := 1.
a + b + e.
a := 1.'.
	pharoBindings := GtLocalVariablesBindings new.
	pharoBindings localAt: #a put: 40.
	pharoBindings localAt: #b put: 41.
	pharoBindings localAt: #e put: 42.
	
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: pharoBindings;
		classSlotNames: #(f);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames sorted equals: #(#a #b #e). 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder requiredVariableNames sorted
		equals: #(#a #b #e).
	self 
		assert: executionBuilder variableNamesToReturn asArray
		equals: #(#a).
		
	self 
		assert: executionBuilder undeclaredVariableNames sorted 
		equals: #(#a #b #e #f).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#f).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a #b #e).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult  x |
f := 1.
a + b + e.
snippetResult := a := 1.
({ #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> complexExpression_withMultipleInvalidBindings [
	<gtExample>
	| source pharoBindings executionBuilder remoteBindings firstInvalidBinding |

	source := 
'| x |
f := 1.
a + b + e.
a := 1.'.
	pharoBindings := GtLocalVariablesBindings new.
	pharoBindings localAt: #a put: GspoString new.
	pharoBindings localAt: #b put: GspoString new.
	pharoBindings localAt: #e put: GspoString new.
	
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: pharoBindings;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames sorted equals: #(#a #b #e). 
	
	self assert: executionBuilder remoteInvalidBindingNames sorted equals: #(a b e).
	executionBuilder 
		withFirstInvalidRemoteBinding: [ :aBinding | firstInvalidBinding := aBinding ].
	self assert: firstInvalidBinding name equals: #a.
	self assert: (executionBuilder errorPositionForBingingNamed: #a) equals: 15.
	self assert: (executionBuilder errorPositionForBingingNamed: #b) equals: 19.
	self assert: (executionBuilder errorPositionForBingingNamed: #e) equals: 23.
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(f).
	self 
		assert: executionBuilder requiredVariableNames sorted
		equals: #(#a #b #e).
		
	self 
		assert: executionBuilder undeclaredVariableNames sorted 
		equals: #(#a #b #e #f).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#f).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a #b #e).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| f snippetResult  x |
f := 1.
a + b + e.
snippetResult := a := 1.
({ #f -> f. #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> complexExpression_withOneInvalidBinding [
	<gtExample>
	| source pharoBindings executionBuilder remoteBindings firstInvalidBinding |

	source := 
'| x |
f := 1.
a + b + e.
a := 1.'.
	pharoBindings := GtLocalVariablesBindings new.
	pharoBindings localAt: #a put: 40.
	pharoBindings localAt: #b put: GspoString new.
	pharoBindings localAt: #e put: 42.
	
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: pharoBindings;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames sorted equals: #(#a #b #e). 
	
	self assert: executionBuilder remoteInvalidBindingNames equals: #(b).
	executionBuilder 
		withFirstInvalidRemoteBinding: [ :aBinding | firstInvalidBinding := aBinding ].
	self assert: firstInvalidBinding name equals: #b.
	self assert: (executionBuilder errorPositionForBingingNamed: #a) equals: 15.
	self assert: (executionBuilder errorPositionForBingingNamed: #b) equals: 19.
	self assert: (executionBuilder errorPositionForBingingNamed: #e) equals: 23.
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(f).
	self 
		assert: executionBuilder requiredVariableNames sorted
		equals: #(#a #b #e).
		
	self 
		assert: executionBuilder undeclaredVariableNames sorted 
		equals: #(#a #b #e #f).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#f).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a #b #e).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| f snippetResult  x |
f := 1.
a + b + e.
snippetResult := a := 1.
({ #f -> f. #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_accessClass [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 'Object new'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtSharedVariablesBindings new;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self assert: executionBuilder requiredVariableNames isEmpty.
	self assert: executionBuilder remoteCodeExtraTemporaryNames isEmpty.
	self assert: executionBuilder undeclaredVariableNames isEmpty.
	

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult |
snippetResult := Object new.
({ #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_accessFirstWriteSecond_noBinding [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 
'a + 3.
a := 4'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtSharedVariablesBindings new;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self assert: executionBuilder requiredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #().
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult |
a + 3.
snippetResult := a := 4.
({ #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_accessFirstWriteSecond_noBinging_classSlot [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 
'a + 3.
a := 4'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtSharedVariablesBindings new;
		classSlotNames: #(a);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self assert: executionBuilder requiredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder variableNamesToReturn asArray
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #().
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult |
a + 3.
snippetResult := a := 4.
({ #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_accessFirstWriteSecond_withBinding [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 
'a + 3.
a := 4'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #a put: 40);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames equals: #(a). 
	self assert: remoteBindings bindings anyOne value equals: 40. 
	
	self assert: executionBuilder requiredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
		
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #().
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult |
a + 3.
snippetResult := a := 4.
({ #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_accessFirstWriteSecond_withBinding_classSlot [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 
'a + 3.
a := 4'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #a put: 40);
		classSlotNames: #(a);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames equals: #(). 
	
	self assert: executionBuilder requiredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder variableNamesToReturn asArray
		equals: #().
		
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #().
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult |
a + 3.
snippetResult := a := 4.
({ #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #'examples - invalid bindings' }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_accessFirstWriteSecond_withInvalidBinding [
	<gtExample>
	| source executionBuilder remoteBindings firstInvalidBinding |

	source := 
'a + 3.
a := 4'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #a put: GspoString new);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames equals: #(a). 
	
	self assert: executionBuilder remoteInvalidBindingNames equals: #(a).
	executionBuilder 
		withFirstInvalidRemoteBinding: [ :aBinding | 
			firstInvalidBinding := aBinding ].
	self assert: firstInvalidBinding name equals: #a.
	self assert: (executionBuilder errorPositionForBingingNamed: #a) equals: 1.
	
	self assert: executionBuilder requiredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
		
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #().
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult |
a + 3.
snippetResult := a := 4.
({ #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_accessGlobal_noBinding [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 'a + 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtSharedVariablesBindings new;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #(a).
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #().
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a).
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_accessGlobal_noBinding_classSlot [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 'a + 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtSharedVariablesBindings new;
		classSlotNames: #(a);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #(a).
	self 
		assert: executionBuilder variableNamesToReturn asArray
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #().
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a).
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_accessGlobal_withBinding [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 'a + 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #a put: 40);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames equals: #(a). 
	self assert: remoteBindings bindings anyOne value equals: 40. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #(a).
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #().
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a).
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_accessGlobal_withBinding_notRelated [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 'a + 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #b put: 40);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #(a).
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #().
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a).
	
	^ executionBuilder
]

{ #category : #'examples - invalid bindings' }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_accessGlobal_withInvalidBinding [
	<gtExample>
	| source executionBuilder remoteBindings  firstInvalidBinding|

	source := 'a + 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #a put: GspoString new);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindingNames equals: #(a). 
	
	self assert: executionBuilder remoteInvalidBindingNames equals: #(a).
	executionBuilder 
		withFirstInvalidRemoteBinding: [ :aBinding | firstInvalidBinding := aBinding ].
	self assert: firstInvalidBinding name equals: #a.
	self assert: (executionBuilder errorPositionForBingingNamed: #a) equals: 1.
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #(a).
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #().
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(#a).
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_writeFirstAccessSecond_noBinding [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 
'a := 4.
a + 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtSharedVariablesBindings new;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(a).
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#a).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #().

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| a snippetResult |
a := 4.
snippetResult := a + 3.
({ #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_writeFirstAccessSecond_noBinding_classSlot [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 
'a := 4.
a + 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtSharedVariablesBindings new;
		classSlotNames: #(a);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #().
	self 
		assert: executionBuilder variableNamesToReturn asArray
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#a).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #().

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult |
a := 4.
snippetResult := a + 3.
({ #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_writeFirstAccessSecond_withBinding [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 
'a := 4.
a + 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #a put: 40);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(a).
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#a).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #().

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| a snippetResult |
a := 4.
snippetResult := a + 3.
({ #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #'examples - invalid bindings' }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_writeFirstAccessSecond_withInvalidBinding [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 
'a := 4.
a + 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #a put: GspoString new);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	
	self assert: executionBuilder remoteInvalidBindingNames equals: #().
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(a).
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#a).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #().

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| a snippetResult |
a := 4.
snippetResult := a + 3.
({ #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_writeGlobal_noBinding [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 'a := 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtSharedVariablesBindings new;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(a).
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(a).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #().
		
	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| a snippetResult |
snippetResult := a := 3.
({ #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_writeGlobal_noBinding_classSlot [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 'a := 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtSharedVariablesBindings new;
		classSlotNames: #(a);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #().
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(a).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #().
		
	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult |
snippetResult := a := 3.
({ #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_writeGlobal_withBinding [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 'a := 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #a put: 40);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(a).
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(a).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #().
		
		self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| a snippetResult |
snippetResult := a := 3.
({ #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_writeGlobal_withBinding_classSlot [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 'a := 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtLocalVariablesBindings new;
		classSlotNames: #(a);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #().
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #().
	self 
		assert: executionBuilder variableNamesToReturn asArray
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(a).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #().
		
		self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult |
snippetResult := a := 3.
({ #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_writeGlobal_withBinding_notRelated [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 'a := 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #b put: 40);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(a).
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(a).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #().
		
	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| a snippetResult |
snippetResult := a := 3.
({ #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #'examples - invalid bindings' }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithGlobal_writeGlobal_withInvalidBinding [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 'a := 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #a put: GspoString new);
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self 
		assert: executionBuilder remoteInvalidBindingNames 
		equals: #().
		
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(a).
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #().
	
	self assert: executionBuilder undeclaredVariableNames asArray equals: #(#a).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(a).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #().
		
		self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| a snippetResult |
snippetResult := a := 3.
({ #a -> a. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithModifiedGlobal [
	<gtExample>
	| source pharoBindings executionBuilder remoteBindings |

	source := 
'answer := input + 2.
input := ''Used''.
answer'.
	pharoBindings := GtLocalVariablesBindings new.
	pharoBindings localAt: #input put: 40.
	
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: pharoBindings;
		sourceString: source.
	
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings size equals: 1. 
	self assert: remoteBindings bindings anyOne name equals: #input.
	self assert: remoteBindings bindings anyOne value equals: 40.
	
	self 
		assert: executionBuilder remoteCodeExtraTemporaryNames asArray 
		equals: #(#answer).
	self 
		assert: executionBuilder requiredVariableNames asArray 
		equals: #(input).
		
	self 
		assert: executionBuilder undeclaredVariableNames asArray 
		equals: #(#input answer).
	self 
		assert: executionBuilder assignFirstUndeclaredVariablesName asArray 
		equals: #(#answer).
	self 
		assert: executionBuilder accessedFirstUndeclaredVariableNames asArray 
		equals: #(input).

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| answer snippetResult |
answer := input + 2.
input := ''Used''.
snippetResult := answer.
({ #input -> input. #answer -> answer. #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithNotRelatedBindings [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := '4+3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: (GtLocalVariablesBindings new
			localAt: #a put: 40);
		sourceString: source.
		 
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self assert: executionBuilder requiredVariableNames isEmpty.
	self assert: executionBuilder remoteCodeExtraTemporaryNames isEmpty.
	
	self assert: executionBuilder undeclaredVariableNames isEmpty.

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult |
snippetResult := 4+3.
({ #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithTemporary [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := 
'| a |
a := 4.
a + 3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtSharedVariablesBindings new;
		sourceString: source.
		
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self assert: executionBuilder requiredVariableNames isEmpty.
	self assert: executionBuilder remoteCodeExtraTemporaryNames isEmpty.
	self assert: executionBuilder undeclaredVariableNames isEmpty.

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult  a |
a := 4.
snippetResult := a + 3.
({ #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]

{ #category : #examples }
GtGemStoneSnippetRemoteExecutionBuilderExamples >> expressionWithoutBindings [
	<gtExample>
	| source executionBuilder remoteBindings |

	source := '4+3'.
	executionBuilder := GtGemStoneSnippetRemoteExecutionBuilder new 
		localBindings: GtSharedVariablesBindings new;
		sourceString: source.
		 
	remoteBindings := executionBuilder extractRemoteBindings.
	self assert: remoteBindings bindings isEmpty. 
	
	self assert: executionBuilder requiredVariableNames isEmpty.
	self assert: executionBuilder remoteCodeExtraTemporaryNames isEmpty.
	
	self assert: executionBuilder undeclaredVariableNames isEmpty.

	self assert: executionBuilder generateRemoteScript withUnixLineEndings equals: 
'| snippetResult |
snippetResult := 4+3.
({ #snippetResult -> snippetResult } collect: [ :___each |
	___each  key -> (___each value class == GtRsrProxyServiceServer
	ifTrue: [___each value ] ifFalse: [ GtRsrProxyServiceServer object: ___each value ]) ])  asDictionary' withUnixLineEndings.
	
	^ executionBuilder
]
