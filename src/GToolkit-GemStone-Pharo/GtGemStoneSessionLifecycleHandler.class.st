Class {
	#name : #GtGemStoneSessionLifecycleHandler,
	#superclass : #Object,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #actions }
GtGemStoneSessionLifecycleHandler >> aboutToAbortSession: aGemStoneSession [
	^ true
]

{ #category : #actions }
GtGemStoneSessionLifecycleHandler >> aboutToCommitSession: aGemStoneSession [
	^ true
]
