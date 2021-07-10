Class {
	#name : 'GtRsrProxyServiceClient',
	#superclass : 'GtRsrProxyService',
	#category : 'GToolkit-GemStone-Pharo'
}

{ #category : 'performing' }
GtRsrProxyServiceClient >> evaluate: aString [
	"Evaluate the supplied string with `self` bound to the receiver"
	| evaluator |

	evaluator := GtRsrEvaluatorServiceClient new
		selfInstance: self;
		script: aString;
		registerWith: _connection.
	^ evaluator doItAndWait.
]

{ #category : 'performing' }
GtRsrProxyServiceClient >> proxyPerform: aSymbol [

	^ (remoteSelf proxyPerform: aSymbol) wait.
]

{ #category : 'performing' }
GtRsrProxyServiceClient >> proxyPerform: aSymbol withArguments: anArray [

	^ remoteSelf proxyPerform: aSymbol withArguments: anArray
]
