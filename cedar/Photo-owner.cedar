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