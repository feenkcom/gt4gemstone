| projectDef projectsHome resolvedProject rsrLoadSpec |
projectsHome := '$ROWAN_PROJECTS_HOME'.					"Assume that the gtoolkit-gemstone project has already been cloned into this directory"
projectsHome := '/home/dhenrich/rogue/_homes/rogue/_home/shared/repos'.
"Create a new project"
projectDef := Rowan newProjectNamed: 'gtoolkit-gemstone'.
projectDef
	specName: 'gtoolkit-gemstone';
	projectsHome: projectsHome;										"location where project will be created, cloned or attached (if the directory projectsHome/<project-name> exists)"
	gitUrl: 'git@github.com:feenkcom/gtoolkit-gemstone.git';	"url used to conditionally clone the git repository when load spec is resolved"
	revision: 'main';														"commitish to be used if/when project is cloned"
	addTopLevelComponentNamed: 'Core';							"primary component name"
	addPlatformComponentNamed: 'Core'
		toComponentNamed: 'Core' 
		pathNameArray: {'gemstone'} 
		conditionPathArray: { { 'gemstone' } };					"conditional gemstone component"
	gemstoneSetDefaultSymbolDictNameForUser: 'SystemUser' 
		to: 'Globals';														"all packages will be loaded into the Globals symbol dictionary"
	packagesPath: 'src';													"relative path from repository root to packages directory"
	addProjectNamed: 'RemoteServiceReplication'
		toComponentNamed: 'Core';									"add dependency on RemoteServiceReplication project"
	packageConvention: 'RowanHybrid';								"I noticed you named your packages GToolkit-GemStone and GToolkit-GemStone-GemStone which is does not conform 
																					to the Monticello package naming convention ... RowanHybrid tolerates these package names"
	addPackageNamed: 'GToolkit-GemStone' 
		toComponentNamed: 'Core';									"GToolkit-GemStone package will be unconditionally loaded"
	addPackageNamed: 'GToolkit-GemStone-GemStone' 
		toComponentNamed: 'gemstone/Core';						"GToolkit-GemStone-GemStone will be loaded when 'gemstone' platform attribute is present"
	yourself.
resolvedProject := projectDef resolve.								"attach resolved project to the existing gtoolkit-gemstone git repository"
resolvedProject
	export;
	exportLoadSpecification.											"write all of the Rowan meta data to disk"
rsrLoadSpec := RwLoadSpecificationV2 new
	specName: 'RemoteServiceReplication';
	projectName: 'RemoteServiceReplication';
	gitUrl: 'git@github.com:GemTalk/RemoteServiceReplication.git';
	revision: 'development';
	componentNames: { 'RemoteServiceReplication' };
	customConditionalAttributes: { 'tests' };
	gemstoneSetDefaultSymbolDictNameForUser: 'SystemUser' 
		to: 'Globals';
	yourself.																	"Create a load spec for the required project RemoteServiceReplication project (duplicate of load spec used by Sparkle)"
rsrLoadSpec exportTo: resolvedProject projectsRoot.			"write the RSR load spec into the rowan/projects directory where the RemoteServiceReplication name (declared earlier) 
																					will be resolved"
