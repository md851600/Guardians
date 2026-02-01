@Regression
Feature: Retail Home Page

Background:
		Given User is on retail website
		
@SideBar
Scenario: 
		When User click on All section
    Then below options are present in Shop by Department sidebar
    |Electronics|Computers|Smart Home|Sports|Automative
   
@SideBarAllOptions
Scenario Outline: Verify department sidebar options
		When User click on All section
   	And user on <department>
   	Then below options are present in department 
   	|<optionOne>| |<optionTwo>|
   
   Examples: 
   |department  |optionOne  |optionTwo|
   |'Electronics' |TV & Video |Video Games|
   |'Computers'   |Accessories|Networking|
   |'Smart Home'  |Smart Home Lightning|Plugs and Outlets|
   |'Sports'      |Athletic Clothing|Exercise & Fitness|
   |'Automotive'  |Automative Parts & Accessories|MotorCycle & Powersports|  