This directory contains a number of scripts for managing the GemStone code, creating a release and running the GemStone examples from the command line.

!! Running Examples from the command line

There are three steps for running the examples:

1. Preconfigure the environment.

This makes the required repositories available in a known location (the Gt image directory), and sets several environment variables.

On Jenkins, this is `jenkins_preconfigure_gemstone.sh`.  This also downloads the GemStone archives to a persistant location so they can be used between CI runs.

`dev_preconfigure_gemstone.sh` configures the environment for a typical developer setup.


2. Set up the GemStone DB and load the code: `setup-remote-gemstone.sh`.

3. Run the examples: `run-remote-gemstone-examples.sh`.`
