fileformat 8bit
set sourcestringclass String

set compile_env: 0
! ------------------- Class definition for GtRsrProxyService
expectvalue /Class
doit
RsrService subclass: 'GtRsrProxyService'
  instVarNames: #( remoteClass)
  classVars: #()
  classInstVars: #()
  poolDictionaries: #()
  inDictionary: Globals
  options: #()

%
expectvalue /Class
doit
GtRsrProxyService category: 'GToolkit-GemStone'
%
! ------------------- Remove existing behavior from GtRsrProxyService
expectvalue /Metaclass3
doit
GtRsrProxyService removeAllMethods.
GtRsrProxyService class removeAllMethods.
%
set compile_env: 0
! ------------------- Class methods for GtRsrProxyService
category: 'accessing'
classmethod: GtRsrProxyService
templateClassName

	^ #GtRsrProxyService
%
! ------------------- Instance methods for GtRsrProxyService
category: 'accessing'
method: GtRsrProxyService
remoteClass
	"Answer the name of the class of the remote object"

	^ remoteClass
%
category: 'accessing'
method: GtRsrProxyService
remoteClass: aSymbol
	"Set the name of the class of the remote object"

	remoteClass := aSymbol
%
