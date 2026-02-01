@Regression 
Feature: Sign in Feature

Background: 
		Given User is on retail website
    When User click on Sign in option

@SignIn
 Scenario: Verify user can sign in into Retail Application
    And User enter email 'david.jaan@gmail.com' and password 'David123$'
    And User click on login button
    Then User should be logged in into Account
    

@SignUp
Scenario: Verify user can create an account into Retail Website
    And User click on Create New Account button
    And User fill the signUp information with below data
    |name|email|password|confirmPassword|
    |firstname|email|David123$|David123$|
    And User click on SignUp button
    Then User should be logged into account page