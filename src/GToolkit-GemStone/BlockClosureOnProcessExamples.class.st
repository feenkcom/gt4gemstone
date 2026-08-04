"
Examples for BlockClosure>>#on:withProcessDo:. They exercise normal evaluation, exception handling in the caller process, access to the suspended failing process, handler arity via cull:, and release of the failing process after the handler completes.
"
Class {
	#name : #BlockClosureOnProcessExamples,
	#superclass : #Object,
	#category : #'GToolkit-GemStone'
}

{ #category : #'as yet unclassified' }
BlockClosureOnProcessExamples >> assert: aBoolean [

	^ self
		gtDo: [ super assert: aBoolean ]
		gemstoneDo: [
	aBoolean ifFalse:
		[ TestResult failure signal: 'Assertion failed'] ].
]

{ #category : #examples }
BlockClosureOnProcessExamples >> blockRunsInCallingProcess [
	<gtExample>
	<return: #Process>
	| callingProcess blockProcess handlerProcess result |
	
	self runAndWait:
		[ callingProcess := Processor activeProcess.
		result := [ blockProcess := Processor activeProcess ]
			on: ZeroDivide
			withProcessDo: [ :exception :process |
				handlerProcess := Processor activeProcess ] ].
	
	self assert: result == callingProcess.
	self assert: callingProcess == blockProcess.
	self assert: handlerProcess isNil.
	^ callingProcess
]

{ #category : #examples }
BlockClosureOnProcessExamples >> evaluatesHandlerAndReturnsItsValueWhenExceptionMatches [
	<gtExample>
	<return: #Array>
	| result |
	
	self runAndWait:
		[ result := [ 1 / 0 ]
			on: ZeroDivide
			withProcessDo: [ :exception :process |
				{ exception class. process class. process isSuspended } ] ].
	
	self assert: result first equals: ZeroDivide.
	self assert: result second equals: self processClass.
	self assert: result third.
	^ result
]

{ #category : #examples }
BlockClosureOnProcessExamples >> exceptionInHandlerIsPropagatedToCaller [
	<gtExample>
	<return: #Symbol>
	| result returned |
	
	self runAndWait:
		[ result := [ [ 1 / 0 ]
		on: ZeroDivide
		withProcessDo: [ :exception :process | 
			self error: 'oops' ] ]
				on: Error
				do: [ :exception | 
					self assert: exception messageText = 'oops'.
					#propagated ].
		returned := true ].

	self assert: returned.
	self assert: result == #propagated.
	^ result
]

{ #category : #examples }
BlockClosureOnProcessExamples >> getCallStack [
	<gtExample>
	<return: #SmallInteger>
	| result |
	
	result := [ 1 / 0 ]
		on: ZeroDivide
		withProcessDo: [ :exception :process |
			self
				gtDo: [ exception stackString ]
				gemstoneDo: [ process stackReportToLevel: 100 withArgsAndTemps: true andMethods: true includeSource: false. ] ].
	
	self assert: result size > 500.
	^ result
]

{ #category : #examples }
BlockClosureOnProcessExamples >> nonMatchingExceptionIsPropagatedToCaller [
	<gtExample>
	<return: #Symbol>
	| result returned |
	
	self runAndWait:
		[ result := [ [ 1 / 0 ]
		on: MessageNotUnderstood
		withProcessDo: [ :exception :process | #unexpected ] ]
			on: ZeroDivide
		do: [ :exception | #propagated ].
		returned := true ].

	self assert: returned.
	self assert: result == #propagated.
	^ result
]

{ #category : #examples }
BlockClosureOnProcessExamples >> oneArgumentHandlerReceivesOnlyTheException [
	<gtExample>
	<return: #ZeroDivide>
	| result |
	
	result := [ 1 / 0 ]
		on: ZeroDivide
		withProcessDo: [ :exception | exception class ].
	
	self assert: result == ZeroDivide.
	^ result
]

{ #category : #private }
BlockClosureOnProcessExamples >> processClass [

	^ self
		gtDo: [ #Process asClass ]
		gemstoneDo: [ (System myUserProfile resolveSymbol: #GsProcess) value ]
]

{ #category : #examples }
BlockClosureOnProcessExamples >> providesTheSeparateFailingProcessToHandler [
	<gtExample>
	<return: #Process>
	| callingProcess failingProcess processState suspendedContext |
	
	callingProcess := Processor activeProcess.
	failingProcess := [ 1 / 0 ]
		on: ZeroDivide
		withProcessDo: [ :exception :process |
			processState := self
				gtDo: [ process state ]
				gemstoneDo: [ process _statusString ].
			suspendedContext := self
				gtDo: [ process suspendedContext ]
				gemstoneDo: [ #ignored ].
			process ].
	
	self assert: failingProcess class == self processClass.
	self assert: failingProcess == callingProcess.
	self assert: processState asString = 'suspended'.
	self assert: suspendedContext notNil.
	^ failingProcess
]

{ #category : #examples }
BlockClosureOnProcessExamples >> returnsReceiverValueWhenNoException [
	<gtExample>
	<return: #SmallInteger>
	| handlerWasEvaluated result |
	
	handlerWasEvaluated := false.
	result := [ 42 ]
		on: ZeroDivide
		withProcessDo: [ :exception :process |
			handlerWasEvaluated := true.
			#handled ].
	
	self assert: result = 42.
	self assert: handlerWasEvaluated not.
	^ result
]

{ #category : #private }
BlockClosureOnProcessExamples >> runAndWait: aBlockClosure [
	| semaphore result proc |
	semaphore := Semaphore new.
	proc := [ result := aBlockClosure value.
		semaphore signal ] fork.
	self waitForSeconds: semaphore.

	^ result
]

{ #category : #private }
BlockClosureOnProcessExamples >> waitForSeconds: semaphore [
	(self
		gtDo: [ semaphore waitTimeoutSeconds: 60 ]
		gemstoneDo: [ (semaphore waitForSeconds: 60) not ])
		ifTrue: [ self error: 'Block didn''t complete in time' ]
]

{ #category : #examples }
BlockClosureOnProcessExamples >> zeroArgumentHandlerIsSupported [
	<gtExample>
	<return: #Symbol>
	| result |
	
	result := [ 1 / 0 ]
		on: ZeroDivide
		withProcessDo: [ #handled ].
	
	self assert: result == #handled.
	^ result
]
