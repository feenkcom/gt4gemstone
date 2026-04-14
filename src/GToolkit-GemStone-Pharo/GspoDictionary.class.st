Class {
	#name : #GspoDictionary,
	#superclass : #GtRsrProxyServiceClient,
	#category : #'GToolkit-GemStone-Pharo-Client'
}

{ #category : #accessing }
GspoDictionary class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ #Dictionary
]

{ #category : #converting }
GspoDictionary >> createGtpoLocalObjectLinkedToBareProxy: aBareProxy [
	"Answer a local copy of the receiver and add a mapping between the local copy and the given bare proxy"
	| instVarDict localObject |

	instVarDict := self evaluateAndWait: self extractAttributesForLocalObjectCode.
	localObject := (self class environment at: remoteClass) new.
	
	(instVarDict at:'array') do: [ :array |
		|key|
		key := array first asGtBareProxyObject.
		localObject 
			at: (key isGtBareProxyObject
				ifTrue: [ key asGtpoLocalObject]
				ifFalse: [ key ] )
			put: array second asGtBareProxyObject].
	self class proxyObjectMap at: localObject put: aBareProxy.
	^ localObject.
]

{ #category : #converting }
GspoDictionary >> extractAttributesForLocalObjectCode [
	^ 'Dictionary new 
	at: ''array'' put: (self associationsAsArray collect: [ :assoc | 
		Array with: assoc key with: assoc value]);
	yourself'
]
