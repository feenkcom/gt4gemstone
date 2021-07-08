| warnings |
warnings := String new.
[
	(Rowan projectFromUrl: 'file:/$GTOOLKIT_GEMSTONE_LOAD_SPEC_FILE_URL')
		projectsHome: '$ROWAN_PROJECTS_HOME';
		load
] on: CompileWarning do: [:ex |
	(ex description includesString: 'not optimized')
			ifFalse: [ warnings 
                           addAll: ex asString;
                           lf ].
	ex resume ].
warnings isEmpty
	ifTrue: [ true ]
	ifFalse: [ warnings ]
