printing
gtGsInspectorSourceCodeIn: aComposite
	
	self 
		gemstoneOrRemoteWith: [ 
			aComposite text
				title: [ 'Source' ];
				display: [ self targetObject sourceString ];
				format: [ :aString | aString ] ]
		using: #gtGsInspectorSourceCodeIn:
		on: aComposite
		