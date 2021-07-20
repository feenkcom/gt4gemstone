fileformat 8bit
set sourcestringclass String

set compile_env: 0
! ------------------- Class definition for GtRsrEvaluatorService
expectvalue /Class
doit
RsrService subclass: 'GtRsrEvaluatorService'
  instVarNames: #()
  classVars: #()
  classInstVars: #()
  poolDictionaries: #()
  inDictionary: Globals
  options: #()

%
expectvalue /Class
doit
GtRsrEvaluatorService comment: 
'GtRsrEvaluatorService provides the ability to evaluate scripts on a GemStone server from a Gtoolkit client, using GemStone''s RemoteServiceReplicator facility.'
%
expectvalue /Class
doit
GtRsrEvaluatorService category: 'GToolkit-GemStone'
%
! ------------------- Remove existing behavior from GtRsrEvaluatorService
expectvalue /Metaclass3
doit
GtRsrEvaluatorService removeAllMethods.
GtRsrEvaluatorService class removeAllMethods.
%
set compile_env: 0
! ------------------- Class methods for GtRsrEvaluatorService
category: 'accessing'
classmethod: GtRsrEvaluatorService
templateClassName

	^ #GtRsrEvaluatorService
%
! ------------------- Instance methods for GtRsrEvaluatorService
category: 'actions'
method: GtRsrEvaluatorService
evaluate: remoteScript for: anObject bindings: remoteBindings

	^ self subclassResponsibility
%
category: 'actions'
method: GtRsrEvaluatorService
evaluateAndWait: remoteScript for: anObject bindings: remoteBindings

	^ self subclassResponsibility
%
