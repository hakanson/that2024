package photoapptest

import rego.v1

# Album DoePhotos
Album_DoePhotos.test_JaneDoe_viewPhoto_JohnDoe if {
	 result := data.photoapp.is_authorized with input as {
    "principal": {
      "type": "PhotoApp::User",
      "id": "JaneDoe"
    },
    "action": "viewPhoto",
    "resource": {
      "type": "PhotoApp::Photo",
      "id": "JohnDoe.jpg"
    },
    "context": {}
  }
  result.decision == "ALLOW"
  result.determiningPolicies["DoePhotos"]
}
Album_DoePhotos.test_JohnDoe_viewPhoto_JaneDoe if {
	result := data.photoapp.is_authorized with input as {
    "principal": {
      "type": "PhotoApp::User",
      "id": "JohnDoe"
    },
    "action": "viewPhoto",
    "resource": {
      "type": "PhotoApp::Photo",
      "id": "JaneDoe.jpg"
    },
    "context": {}
  }
  result.decision == "ALLOW"
  result.determiningPolicies["DoePhotos"]
}

# Role PhotoJudge
Role_PhotoJudge.test_JorgeSouza_viewPhoto_sunset_session if {
	result := data.photoapp.is_authorized with input as {
    "principal": {
      "type": "PhotoApp::User",
      "id": "JorgeSouza"
    },
    "action": "viewPhoto",
    "resource": {
      "type": "PhotoApp::Photo",
      "id": "sunset.jpg"
    },
    "context": {
      "judgingSession": true
    }
  }
  result.decision == "ALLOW"
  result.determiningPolicies["PhotoJudge"]
}
Role_PhotoJudge.test_JorgeSouza_viewPhoto_sunset_nosession if {
	result := data.photoapp.is_authorized with input as {
    "principal": {
        "type": "PhotoApp::User",
        "id": "JorgeSouza"
    },
    "action": "viewPhoto",
    "resource": {
        "type": "PhotoApp::Photo",
        "id": "sunset.jpg"
    },
    "context": {
        "judgingSession": false
    }
  }
  result.decision == "DENY"
}

# User JorgeSouza
User_JorgeSouza.test_JorgeSouza_viewPhoto_Judges if {
	result := data.photoapp.is_authorized with input as {
    "principal": {
      "type": "PhotoApp::User",
      "id": "JorgeSouza"
    },
    "action": "viewPhoto",
    "resource": {
      "type": "PhotoApp::Photo",
      "id": "Judges.jpg"
    },
    "context": {}
  }
  result.decision == "ALLOW"
  result.determiningPolicies["Photo-subjects"]
}