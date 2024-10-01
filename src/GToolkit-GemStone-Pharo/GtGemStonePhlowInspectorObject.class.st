Class {
	#name : #GtGemStonePhlowInspectorObject,
	#superclass : #GtRemotePhlowInspectorObject,
	#category : #'GToolkit-GemStone-Pharo-UI'
}

{ #category : #configuring }
GtGemStonePhlowInspectorObject >> configurePageViewModel: aPageViewModel [
	aPageViewModel sharedSnippetContext externalSnippetContext 
		gemstoneBehaviourSpecification: objectInspectorAdaptor gtRemoteBehaviourSpecification
]
