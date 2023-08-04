Extension { #name : #ClassDescription }

{ #category : #'*GToolkit-GemStone-Pharo' }
ClassDescription >> gemstoneDefinitionString [

	^ self gemstoneDefinitionStringBasedOn: nil
]

{ #category : #'*GToolkit-GemStone-Pharo' }
ClassDescription >> gemstoneDefinitionStringBasedOn: aGtpoMetaclass3 [
	| inDictionaryName optionsString arrayFormatter space |

	inDictionaryName := aGtpoMetaclass3
		ifNil: [ GtpoMetaclass3 defaultDictionary value ]
		ifNotNil: [ aGtpoMetaclass3 asGtProxyObject globalsDictionaryName ].
	optionsString := aGtpoMetaclass3
		ifNil: [ '#()' ]
		ifNotNil: [ aGtpoMetaclass3 asGtBareProxyObject _optionsArrayForDefinition storeString ].
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
			<< self superclass name;
			<< ' subclass: ''';
			<< self name;
			nextPut: $';
			lf; space; space;
			<< 'instVarNames: ';
			<< (arrayFormatter value: self instVarNames);
			lf; space; space;
			<< 'classVars: ';
			<< (arrayFormatter value: self classVarNames);
			lf; space; space;
			<< 'classInstVars: ';
			<< (arrayFormatter value: self class instVarNames);
			lf; space; space;
			<< 'poolDictionaries: ';
			<< (arrayFormatter value: ((Character space split: self sharedPoolsString) reject: #isEmpty));
			lf; space; space;
			<< 'inDictionary: ';
			<< inDictionaryName;
			lf; space; space;
			<< 'options: ';
			<< optionsString;
			lf ].
]
