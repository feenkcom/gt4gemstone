Class {
	#name : #GtGemStoneClassMigrator,
	#superclass : #Object,
	#instVars : [
		'session'
	],
	#category : #'GToolkit-GemStone-Pharo-Utilities'
}

{ #category : #'instance creation' }
GtGemStoneClassMigrator class >> onSession: aGtGemStoneSession [
    ^ self new
        session: aGtGemStoneSession;
        yourself
]

{ #category : #private }
GtGemStoneClassMigrator >> compileMethod: method forClassNamed: className meta: isMeta [
    "Generate a script that compiles the supplied method on GemStone, then send and evaluate the script."
    
    self session evaluateAndWait:
    	(GtGemStoneClassDefinitionTool compileScriptFor: method className: className meta: isMeta)
]

{ #category : #private }
GtGemStoneClassMigrator >> migrateClassNamed: classNameString [
    | class methodDicts className |

	className := classNameString asSymbol.
    class := Smalltalk at: className ifAbsent: [ 
        self error: 'Class ', classNameString, ' does not exist locally.' ].

	self removeMethodsFrom: className.
	self updateClassDefinitionOf: className.

    "Compile all instance and class methods"
    methodDicts := {
        class -> false.
        class class -> true.
    }.

    methodDicts do: [ :pair | | k isMeta |
        k := pair key.
        isMeta := pair value.
        k methodDictionary values do: [ :m |
            self compileMethod: m forClassNamed: class name meta: isMeta ].
    ].
]

{ #category : #private }
GtGemStoneClassMigrator >> migrateMethodsFrom: className [
    | class classSides |

    class := Smalltalk at: className ifAbsent: [ 
        self error: 'Class ', className, ' does not exist locally.' ].

    "Compile all instance and class methods"
    classSides := {
        class -> false.
        class class -> true.
    }.

    classSides do: [ :pair | | k isMeta |
        k := pair key.
        isMeta := pair value.
        k methodDictionary values do: [ :method |
            self compileMethod: method forClassNamed: class name meta: isMeta ].
    ].
]

{ #category : #private }
GtGemStoneClassMigrator >> removeMethodsFrom: className [
	"Remove all instance and class methods from the specified class on GemStone.
	Do nothing if the class doesn't exist.
	Currently assumes the class exists in the Globals dictionary."
    | defScript |

	defScript := String streamContents: [ :stream |
		stream
            nextPutAll: 'Globals at: #';
            nextPutAll: className; 
            nextPutAll: ' ifPresent: [ :cls | ';
            cr; tab;
            nextPutAll: 'cls removeAllMethods.';
            cr; tab;
            nextPutAll: 'cls class removeAllMethods. ].' ].

    "Send the class definition script"
	session evaluateAndWait: defScript.
]

{ #category : #accessing }
GtGemStoneClassMigrator >> session [
	^ session
]

{ #category : #actions }
GtGemStoneClassMigrator >> session: aGtGemStoneSession [

	session := aGtGemStoneSession
]

{ #category : #private }
GtGemStoneClassMigrator >> updateClassDefinitionOf: className [
    | classDefinitionTool |

	classDefinitionTool := GtGemStoneClassDefinitionTool targetClassName: className session: session.
	classDefinitionTool definitionsDiffer ifTrue:
		[ classDefinitionTool compileGs: classDefinitionTool gsDefinitionStringFromGt ].
]
