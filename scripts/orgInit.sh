#!/bin/bash
# Change -a to whatever alias you want
sfdx force:org:create -f ./config/project-scratch-def.json -a cachedemo -s -d 3

# Push source code
sfdx force:source:push

#Open org
sfdx force:org:open
