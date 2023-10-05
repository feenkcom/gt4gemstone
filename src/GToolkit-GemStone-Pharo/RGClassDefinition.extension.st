Extension { #name : #RGClassDefinition }

{ #category : #'*GToolkit-GemStone-Pharo' }
RGClassDefinition >> gemstoneDefinitionScript [
	"Answer a script that will compile the receiver on GemStone,
	using the existing dictionary and options if the class already exists"
	| arrayFormatter space |

	space := Character space.
	arrayFormatter := [ :array |
		String streamContents: [ :stream |
			stream << '#('.
			array do: [ :each |
				stream
					nextPut: space;
					<< each ].
			stream nextPut: $) ] ].
	^ String streamContents: [ :stream |
		stream
			<< '| existingClass inDictionaryName options |'; lf;
			<< 'existingClass := Globals at: #';
				<< name;
				<< ' ifAbsent: [ | classCollection | ';
				<< 'classCollection := Object allSubclasses select: [ :each | each name = #';
				<< name;
				<< ' ]. ';
				<< 'classCollection isEmpty ifTrue: [ nil ] ifFalse: [ classCollection at: 1 ] ].'; lf;
			<< 'inDictionaryName := existingClass ifNil: [ ';
				<< (GtpoMetaclass3 defaultDictionary value: self realClass);
				<< ' ] ifNotNil: [ GsSession currentSession symbolList objectNamed: (existingClass _dictionaryNameForFileout: System myUserProfile) ].'; lf;
			<< 'options := existingClass ifNil: [ #() ] ifNotNil: [ existingClass _optionsArrayForDefinition ].'; cr;
			<< self realClass superclass name;
			<< ' subclass: ''';
			<< name;
			nextPut: $';
			lf; space; space;
			<< 'instVarNames: ';
			<< (arrayFormatter value: self instVarNames);
			lf; space; space;
			<< 'classVars: ';
			<< (arrayFormatter value: self classVarNames);
			lf; space; space;
			<< 'classInstVars: ';
			<< (arrayFormatter value: self realClass class instVarNames);
			lf; space; space;
			<< 'poolDictionaries: ';
			<< (arrayFormatter value: self sharedPoolNames);
			lf; space; space;
			<< 'inDictionary: inDictionaryName';
			lf; space; space;
			<< 'options: options.';
			lf ].
]
