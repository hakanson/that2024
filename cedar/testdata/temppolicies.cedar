// temppolicies.cedar generated
// file: ../DoePhotos.cedar
@id("DoePhotos")
// allow DoeFamily to view DoePhotos
permit (
  principal in PhotoApp::UserGroup::"DoeFamily",
  action == PhotoApp::Action::"viewPhoto",
  resource in PhotoApp::Album::"DoePhotos"
);

// file: ../JaneVacation.cedar
@id("JaneVacation")
// allow JohnDoe to view JaneVacation
permit (
  principal == PhotoApp::User::"JohnDoe",
  action == PhotoApp::Action::"viewPhoto",
  resource in PhotoApp::Album::"JaneVacation"
);

// file: ../Photo-labels-private.cedar
@id("Photo-labels-private")
// deny access to private Photos from non-owner
forbid (
  principal,
  action,
  resource in PhotoApp::Application::"PhotoApp"
)
when { resource.labels.contains("private") }
unless { resource.owner == principal };

// file: ../Photo-owner.cedar
@id("Photo-owner")
// allow resource.owner full access to Photos
permit (
  principal,
  action in
    [PhotoApp::Action::"viewPhoto",
     PhotoApp::Action::"editPhoto",
     PhotoApp::Action::"deletePhoto"],
  resource in PhotoApp::Application::"PhotoApp"
)
when { resource.owner == principal };

// file: ../Photo-subjects.cedar
@id("Photo-subjects")
// allow entity subjects to view Photos
permit (
  principal,
  action == PhotoApp::Action::"viewPhoto",
  resource in PhotoApp::Application::"PhotoApp"
)
when { resource has subjects && resource.subjects.contains(principal) };

// file: ../PhotoJudge.cedar
@id("PhotoJudge")
// conditionally allow PhotoJudge to view "contest" Photos
permit (
  principal in PhotoApp::Role::"PhotoJudge",
  action == PhotoApp::Action::"viewPhoto",
  resource in PhotoApp::Application::"PhotoApp"
)
when { resource.labels.contains("contest") }
when { context has judgingSession && context.judgingSession == true };

// file: ../viewPhoto.template.cedar
@id("viewPhoto.template")
// viewPhoto template
permit (
  principal in ?principal,
  action == PhotoApp::Action::"viewPhoto",
  resource in ?resource
);