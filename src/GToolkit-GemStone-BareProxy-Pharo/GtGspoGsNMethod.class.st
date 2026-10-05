Class {
	#name : #GtGspoGsNMethod,
	#superclass : #GtGsBareProxy,
	#category : #'GToolkit-GemStone-BareProxy-Pharo-Model'
}

{ #category : #accessing }
GtGspoGsNMethod class >> remoteClassName [

	^ #GsNMethod
]

{ #category : #ui }
GtGspoGsNMethod >> asGtMethodCoderModel [
	^ GtGemStoneMethodCoderModel fromGsMethod: self
]
