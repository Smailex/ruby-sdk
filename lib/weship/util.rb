module Weship
	module Error
		WRONG_PACKAGE_TYPE = "ERR: Wrong package type, it should be 'box' or 'envelope\n"
		WRONG_DIMENSIONS = "ERR: Dimensions should be a hash with 4 numbers: weight, length, width and height.\n"
		WRONG_UNITS = "ERR: Wrong units. Units must be 'imperial' or 'metric'\n"
		ADDRESS_PARAM_NOT_DEFINED = "ERR: Address should contain mandatory fileds: zip, country, state, city, line1. Or only zip as minimal address.\n"
		WRONG_PHONE_FORMAT = "ERR: Phone number should have 10 digits long.\n"
		WRONG_EMAIL_FORMAT = "ERR: Given email don't seems to be valid.\n"
		NO_SHIPMENT_ID_PRESENT = "ERR: Shipment ID can't be null.\n"
		PARAMS_NIL_ERR = "parameters couldn't be nil.\n"
	end
end
