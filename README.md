# gt4gemstone
A Gtoolkit interface to GemStone

## Installation

To install the Pharo component in a Gt image (currently only tested in a vanilla Pharo 9 image):

```smalltalk
Metacello new
	repository: 'github://feenkcom/gt4gemstone:main/src';
	baseline: 'GtGemstoneClient';
	load
```

Installation in to the GemStone server is TBS.


## Testing the installation

All tests in `GToolkit-GemStone-Test` package should pass.

With the GemStone RSR server running (`Sparkle/src-gs/server.sh`):

```smalltalk
| connection evaluatorServiceClient result |

connection := (RsrInitiateConnection host: 'localhost' port: 29299) connect.
evaluatorServiceClient := GtRsrEvaluatorServiceClient new.
evaluatorServiceClient registerWith: connection.

result := evaluatorServiceClient 
	evaluateAndWait: 'self + three' 
	for: 4 
	bindings: { #three -> 3 } asDictionary.
{ result. connection.  evaluatorServiceClient. }
```

The result should be a `RsrPromise` with value `7`.
