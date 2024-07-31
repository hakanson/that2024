// allow DoeFamily to view DoePhotos
permit (
  principal in PhotoApp::UserGroup::"DoeFamily",
  action == PhotoApp::Action::"viewPhoto",
  resource in PhotoApp::Album::"DoePhotos"
);