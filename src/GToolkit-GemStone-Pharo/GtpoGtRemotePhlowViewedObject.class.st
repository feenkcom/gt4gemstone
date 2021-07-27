Class {
	#name : 'GtpoGtRemotePhlowViewedObject',
	#superclass : 'GtRsrProxyServiceClient',
	#category : 'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject class >> remoteClassName [

	^ #GtRemotePhlowViewedObject
]

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject >> getGtViewMethodNames [
	^ self proxyPerform: #getGtViewMethodNames
]

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject >> getViewDeclaration: aViewSelector [ 
	^ self
		proxyPerform: #getViewDeclaration:
		withArguments: { aViewSelector asSymbol }
]

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject >> retrieveItemsCount: anItemsCount fromIndex: anIndex forViewSelector: aViewSelector [
	^ self
		proxyPerform: #retrieveItemsCount:fromIndex:forViewSelector:
		withArguments: { anItemsCount . anIndex . aViewSelector }
]

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject >> retrieveTotalItemsCountForViewSelector: methodName [
	^ self
		proxyPerform: #retrieveTotalItemsCountForViewSelector: 
		withArguments: { methodName }
]

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject >> retriveFormattedItemsForViewSelector: methodName [
	^ self
		proxyPerform: #retriveFormattedItemsForViewSelector: 
		withArguments: { methodName }
]

{ #category : 'accessing' }
GtpoGtRemotePhlowViewedObject >> retriveSentItemForViewSelector: methodName atIndex: selectionIndex [
	^ self
		proxyPerform: #retriveSentItemForViewSelector:atIndex:
		withArguments: { methodName . selectionIndex }
]
