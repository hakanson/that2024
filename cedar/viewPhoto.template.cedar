// viewPhoto template
permit (
  principal in ?principal,
  action == PhotoApp::Action::"viewPhoto",
  resource in ?resource
);