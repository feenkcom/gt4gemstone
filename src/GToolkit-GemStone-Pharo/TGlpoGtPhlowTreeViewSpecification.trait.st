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
	^ self
		proxyPerform: #retrieveSentItemAtPath:
		withArguments: { aNodePath }
]

{ #category : #accessing }
TGlpoGtPhlowTreeViewSpecification >> retriveSentItemAtPath: aNodePath [
	^ self
		proxyPerformReturnProxy: #retriveSentItemAtPath:
		withArguments: { aNodePath }
]
