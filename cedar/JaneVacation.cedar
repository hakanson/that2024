// allow JohnDoe to view JaneVacation
permit (
  principal == PhotoApp::User::"JohnDoe",
  action == PhotoApp::Action::"viewPhoto",
  resource in PhotoApp::Album::"JaneVacation"
);