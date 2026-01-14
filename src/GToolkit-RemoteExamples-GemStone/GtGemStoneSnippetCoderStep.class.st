Class {
	#name : #GtGemStoneSnippetCoderStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : #'GToolkit-RemoteExamples-GemStone'
}

{ #category : #'steps - checks' }
GtGemStoneSnippetCoderStep >> assertBinding: aBindingKey is: anObject [
	| anAssertStep |
	anAssertStep := self check
			label: ('Assert binding {1} is {2}'
					format: {aBindingKey.
							anObject});
			satisfies: [ :aCoderElement | 
				aCoderElement textualCoderViewModel pharoBindings 
					bindingValueOf: aBindingKey
					ifPresent: [ :aBindingValue |
						aBindingValue = anObject ]
					ifAbsent: [false] ];
			referenceSender;
			onParentStepTarget: self.

	^ anAssertStep
]

{ #category : #'steps - checks' }
GtGemStoneSnippetCoderStep >> assertBinding: aBindingKey isProxyWithDisplayString: aString [ 
	| anAssertStep |
	anAssertStep := self check
			label: ('Assert binding  value for {1} satisfies condition.'
					format: {aBindingKey});
			satisfies: [ :aCoderElement | 
				aCoderElement textualCoderViewModel pharoBindings 
					bindingValueOf: aBindingKey
					ifPresent: [ :aBindingValue |
						aBindingValue class = GtGsBareProxy and: [
							aBindingValue gtDisplayString = aString ]  ]
					ifAbsent: [false] ];
			referenceSender;
			onParentStepTarget: self.

	^ anAssertStep
]

{ #category : #'steps - checks' }
GtGemStoneSnippetCoderStep >> assertBindingNotPresent: aBindingKey [
	| anAssertStep |
	anAssertStep := self check
			label: ('Assert binding {1} not present'
					format: {aBindingKey});
			satisfies: [ :aCoderElement | 
				aCoderElement textualCoderViewModel pharoBindings 
					bindingValueOf: aBindingKey
					ifPresent: [ :aBindingValue | false ]
					ifAbsent: [ true ] ];
			referenceSender;
			onParentStepTarget: self.

	^ anAssertStep
]

{ #category : #'steps - checks' }
GtGemStoneSnippetCoderStep >> assertBindingValueFor: aBindingKey satisfies: aBlock [
	| anAssertStep |
	anAssertStep := self check
			label: ('Assert binding  value for {1} satisfies condition.'
					format: {aBindingKey});
			satisfies: [ :aCoderElement | 
				| coderModel |
				coderModel := aCoderElement textualCoderViewModel coderModel.
				coderModel pharoBindings 
					bindingValueOf: aBindingKey
					ifPresent: [ :aBindingValue |
						aBlock cull: aBindingValue ]
					ifAbsent: [false] ];
			referenceSender;
			onParentStepTarget: self.

	^ anAssertStep
]

{ #category : #'steps - checks' }
GtGemStoneSnippetCoderStep >> assertErrorIndicatorPresent [

	self check
		label: ('Assert error message button present');
		exists;
		onParentStepTarget: self;
		// GtSourceCoderErrorButtonElementId.
]

{ #category : #'steps - checks' }
GtGemStoneSnippetCoderStep >> assertErrorMessage: anErrorMessage [

	^ self assert
		label: 'Assert error message content';
		value: [ :aTextElement | 
			aTextElement text asString ]
				equals: [ :aMessage | anErrorMessage ];
		onSpaceRoot;
		onDropdown: true;
		/ GtSourceCoderErrorContentElementId;
		/ BlTextElement  
]

{ #category : #'steps - checks' }
GtGemStoneSnippetCoderStep >> assertEvaluationResultIndicatorExists [
	| anAssertStep |
	anAssertStep := self assert
			label: 'Assert evaluation result indicator button exists';
			exists;
			referenceSender;
			onParentStepTarget: self;
			// GtCoderEvaluationResultAttributeElementId.

	^ anAssertStep
]

{ #category : #'steps - checks' }
GtGemStoneSnippetCoderStep >> assertInvalidBinding: aBindingKey [
	| anAssertStep |
	anAssertStep := self check
			label: ('Assert binding {1} is invalid'
					format: {aBindingKey});
			satisfies: [ :aCoderElement | 
				| coderViewModel session |
				coderViewModel := aCoderElement textualCoderViewModel .
				session := coderViewModel evaluationContext session.
				coderViewModel pharoBindings 
					bindingValueOf: aBindingKey
					ifPresent: [ :aBindingValue |
						(GtGemStoneWorkspaceVariable new 
							value: aBindingValue;
							name: aBindingKey;
							gemstoneSession: session) isInvalidBinding ]
					ifAbsent: [false] ];
			referenceSender;
			onParentStepTarget: self.

	^ anAssertStep
]

{ #category : #'steps - interactions' }
GtGemStoneSnippetCoderStep >> clickOnDoItAndInspectAsynchronousButton [
	| aClickStep |
	aClickStep := self click
			referenceSender;
			label: 'Click on play and inspect asynchronous button';
			// GtSourceCoderDoItAndGoAsynchronousActionId.
	^ aClickStep
]

{ #category : #'steps - interactions' }
GtGemStoneSnippetCoderStep >> clickOnDoItAndInspectButton [
	| aClickStep |
	aClickStep := self click
			referenceSender;
			label: 'Click on do it and inspect button';
			// GtSourceCoderDoItAndGoActionId.
	^ aClickStep
]

{ #category : #'steps - interactions' }
GtGemStoneSnippetCoderStep >> clickOnDoItAsynchronousButton [
	| aClickStep |
	aClickStep := self click
			referenceSender;
			label: 'Click on play asynchronous button';
			// GtSourceCoderDoItAsynchronousActionId.
	^ aClickStep
]

{ #category : #'steps - interactions' }
GtGemStoneSnippetCoderStep >> clickOnDoItButton [
	| aClickStep |
	aClickStep := self click
			referenceSender;
			label: 'Click on do it button';
			// GtSourceCoderDoItActionId.
	^ aClickStep
]

{ #category : #'steps - actions' }
GtGemStoneSnippetCoderStep >> updateBinding: aBindingKey to: anObject [
	| anAssertStep |
	anAssertStep := self do
			label: ('Updating binding {1} is {2}'
					format: {aBindingKey.
							anObject});
			action: [ :aCoderElement | 
				(aCoderElement textualCoderViewModel pharoBindings 
					bindingOf: aBindingKey)
						value: anObject ];
			referenceSender;
			onParentStepTarget: self.

	^ anAssertStep
]

{ #category : #'steps - interactions' }
GtGemStoneSnippetCoderStep >> useDoItAndInspectAsynchronousShortcut [
	^ self shortcut
		label: 'Do it and inspect (asynchronous)';
		combination: GtSourceCoderDoItAndInspectAsynchronousShortcut new 
			combination;
		onParentStepTarget: self;
		onThisOrDeepChildElementId: GtSourceCoderEditorInnerId;
		onTopMost
]
