// deny access to private Photos from non-owner
forbid (
  principal,
  action,
  resource in PhotoApp::Application::"PhotoApp"
)
when { resource.labels.contains("private") }
unless { resource.owner == principal };