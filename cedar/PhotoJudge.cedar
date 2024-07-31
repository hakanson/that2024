// conditionally allow PhotoJudge to view "contest" Photos
permit (
  principal in PhotoApp::Role::"PhotoJudge",
  action == PhotoApp::Action::"viewPhoto",
  resource in PhotoApp::Application::"PhotoApp"
)
when { resource.labels.contains("contest") }
when { context has judgingSession && context.judgingSession == true };