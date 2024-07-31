// allow entity subjects to view Photos
permit (
  principal,
  action == PhotoApp::Action::"viewPhoto",
  resource in PhotoApp::Application::"PhotoApp"
)
when { resource has subjects && resource.subjects.contains(principal) };