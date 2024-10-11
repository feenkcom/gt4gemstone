Extension { #name : #GciThreadSafeInterface }

{ #category : #'*GToolkit-GemStone-Pharo' }
GciThreadSafeInterface >> logoutNoError: noError [

"Logout the session. If noError is true, then errors are ignored and no exceptions are raised.
If noError is false, raise an exception if the session is already logged out or if the FFI call returns
anything but 1."
| result tracker gsError |
self isLoggedIn ifFalse:[
	^  noError ifTrue:[ true ] ifFalse:[ self error: 'session is not logged in' ].
].

tracker := GsMemoryTracker new.
gsError := tracker add: GciErrSType externalNew .

GtGemStoneSession logMessage: DateAndTime now printString, ': [BEGIN] GciTsLogout'.
result := self ffiDo: [ 
	self gciTsLogout: session gsError: gsError ].
GtGemStoneSession logMessage: DateAndTime now printString, ': [END] GciTsLogout'.
	
session := nil.
((result == 1) or:[ noError]) ifTrue:[
	tracker freeAll.
	^true
].
"Got an error logging out"

result := GciError newForError:  gsError. "Build a coherent exception before freeing gsError"
[result signal: result message ] ensure:[ tracker freeAll ]

]
