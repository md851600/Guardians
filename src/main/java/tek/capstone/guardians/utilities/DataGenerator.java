package tek.capstone.guardians.utilities;

import com.github.javafaker.Faker;

public class DataGenerator {

	public static String addressGenerator(String input) {

		Faker faker = new Faker();

		String output = "";

		if (input.equalsIgnoreCase("countryValue")) {
			output = "United States";
		} else if (input.equalsIgnoreCase("fullnameValue")) {
			output = faker.name().fullName();
		} else if (input.equalsIgnoreCase("PhoneValue")) {
			output = faker.phoneNumber().cellPhone();
		} else if (input.equalsIgnoreCase("stAddress")) {
			output = faker.address().streetAddress();
		} else if (input.equalsIgnoreCase("aptValue")) {
			output = faker.address().secondaryAddress();
		} else if (input.equalsIgnoreCase("cityValue")) {
			output = faker.address().city();
		} else if (input.equalsIgnoreCase("stateValue")) {
			output = faker.address().state();
		} else if (input.equalsIgnoreCase("zipCodeValue")) {
			String zipcode = faker.address().zipCode().substring(0, 5);
			output = zipcode;
		} else if (input.equalsIgnoreCase("firstname")) {
			output = faker.name().firstName();
		} else if (input.equalsIgnoreCase("email")) {
			output = faker.name().lastName() + "786@gmail.com";
		} else if (input.equalsIgnoreCase("debit")) {
			output = faker.number().digits(16);
		}
		return output;

	}
}