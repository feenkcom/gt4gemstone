fileformat 8bit
set sourcestringclass String

set compile_env: 0
! ------------------- Class definition for GtRsrProxyServiceServer
expectvalue /Class
doit
GtRsrProxyService subclass: 'GtRsrProxyServiceServer'
  instVarNames: #( object)
  classVars: #()
  classInstVars: #()
  poolDictionaries: #()
  inDictionary: Globals
  options: #()

%
expectvalue /Class
doit
GtRsrProxyServiceServer category: 'GToolkit-GemStone'
%
! ------------------- Remove existing behavior from GtRsrProxyServiceServer
expectvalue /Metaclass3
doit
GtRsrProxyServiceServer removeAllMethods.
GtRsrProxyServiceServer class removeAllMethods.
%
set compile_env: 0
! ------------------- Class methods for GtRsrProxyServiceServer
category: 'other'
classmethod: GtRsrProxyServiceServer
object: anObject

	^ self new object: anObject
%
! ------------------- Instance methods for GtRsrProxyServiceServer
category: 'accessing'
method: GtRsrProxyServiceServer
object
	"Answer the object being proxied"

	^ object
%
category: 'accessing'
method: GtRsrProxyServiceServer
object: anObject
	"Set the object being proxied"

	object := anObject.
	remoteClass := anObject class name.
%
category: 'performing'
method: GtRsrProxyServiceServer
proxyPerform: aSymbol

	^ object perform: aSymbol
%
category: 'performing'
method: GtRsrProxyServiceServer
proxyPerform: aSymbol withArguments: anArray

	^ object perform: aSymbol withArguments: anArray
%
