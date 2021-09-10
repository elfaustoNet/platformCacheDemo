#!/bin/bash
# Change -a to whatever alias you want
sfdx force:org:create -f ./config/project-scratch-def.json -a cachedemo -s -d 3 -w 10

# Push source code
sfdx force:source:push -u cachedemo
# Add permission set
sfdx force:user:permset:assign -u cachedemo -n Cache_Demo
#Open org
sfdx force:org:open -u cachedemo
