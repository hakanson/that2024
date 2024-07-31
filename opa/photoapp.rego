# METADATA
# scope: package
# schemas:
#   - input: schema["regoinput-schema"]
package photoapp

import rego.v1  # Implies future.keywords.if and future.keywords.contains

# METADATA
# title: default DENY
default is_authorized := {
	"decision": "DENY", # ALLOW | DENY
	"determiningPolicies": [],
}

# METADATA
# title: forbid policies always DENY authorization
is_authorized := {
	"decision": "DENY",
	"determiningPolicies": policies_forbid,
} if {
	count(policies_forbid) > 0
}

# METADATA
# title: forbid overrides permit
is_authorized := {
	"decision": "ALLOW",
	"determiningPolicies": policies_permit,
} if {
	count(policies_forbid) == 0
	count(policies_permit) > 0
}

# default policies_forbid := set()
policies_forbid contains "" if false # regal ignore:constant-condition

# default policies_permit := set()
policies_permit contains "" if false # regal ignore:constant-condition

## policy rules

# allow DoeFamily to view DoePhotos
policies_permit contains "DoePhotos" if {
	some p in principal_parents
	p.type == "PhotoApp::UserGroup"
	p.id == "DoeFamily"
	input.action == "viewPhoto"
	some r in resource_parents
	r.type == "PhotoApp::Album"
	r.id == "DoePhotos"
}

# allow JohnDoe to view JaneVacation
policies_permit contains "JaneVacation" if {
	input.principal.type == "PhotoApp::User"
	input.principal.id == "JohnDoe"
	input.action == "viewPhoto"
	some r in resource_parents
	r.type == "PhotoApp::Album"
	r.id == "JaneVacation"
}

# deny access to private Photos from non-owner
policies_forbid contains "Photo-labels-private" if {
	input.resource.type == "PhotoApp::Photo"
	"private" in resource_attrs.labels
}

# allow resource.owner full access to Photos
policies_permit contains "Photo-owner" if {
	input.action in ["viewPhoto", "editPhoto", "deletePhoto"]
	input.resource.type == "PhotoApp::Photo"
	resource_attrs.owner.type == input.principal.type
	resource_attrs.owner.id == input.principal.id
}

# allow entity subjects to view Photos
policies_permit contains "Photo-subjects" if {
	input.action == "viewPhoto"
	input.resource.type == "PhotoApp::Photo"
	some subjects in resource_attrs.subjects
	subjects.type == input.principal.type
	subjects.id == input.principal.id
}

# conditionally allow PhotoJudge to view "contest" Photos
policies_permit contains "PhotoJudge" if {
	some p in principal_parents
	p.type == "PhotoApp::Role"
	p.id == "PhotoJudge"
	input.action == "viewPhoto"
	input.resource.type == "PhotoApp::Photo"
	"contest" in resource_attrs.labels
	input.context.judgingSession
}

## helper rules

principal_parents := data.type[input.principal.type][input.principal.id].parents

resource_parents := data.type[input.resource.type][input.resource.id].parents

resource_attrs := data.type[input.resource.type][input.resource.id].attrs
