instance creation
newClientForSessionDescriptionNamed: aSessionDescriptionOrStoneName
	^ self newClientForSessionDescription: (GsDevKit_home sessionDescriptionNamed: aSessionDescriptionOrStoneName)