Trait {
	#name : #TGlpoGtPhlowTreeViewSpecification,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
TGlpoGtPhlowTreeViewSpecification >> retrieveChildrenForNodeAtPath: aNodePath [
	^ self
		proxyPerform: #retrieveChildrenForNodeAtPath:
		withArguments: { aNodePath }
]

{ #category : #accessing }
TGlpoGtPhlowTreeViewSpecification >> retrieveSentItemAtPath: aNodePath [
	^ (self
		proxyPerformReturnProxy: #retrieveSentItemAtPath:
		withArguments: { aNodePath }) asGtBareProxyObject
]

{ #category : #accessing }
TGlpoGtPhlowTreeViewSpecification >> retriveSentItemAtPath: aNodePath [
	^ (self
		proxyPerformReturnProxy: #retriveSentItemAtPath:
		withArguments: { aNodePath }) asGtBareProxyObject
]
