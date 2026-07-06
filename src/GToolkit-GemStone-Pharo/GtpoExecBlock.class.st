Class {
	#name : #GtpoExecBlock,
	#superclass : #GtpoBlockClosure,
	#category : #'GToolkit-GemStone-Pharo-Proxies'
}

{ #category : #accessing }
GtpoExecBlock class >> remoteClassMatcher [
	"Answer the block that matches a given class name"

	^ [ :aSymbol | aSymbol beginsWith: 'ExecBlock' ]
]

{ #category : #accessing }
GtpoExecBlock class >> remoteClassName [
	"Answer the name of the remote class the receiver represents"
	<return: #Symbol or: nil>

	^ #GtpoExecBlock
]
