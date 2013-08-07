package org.granite.math
{

	/**
	 * This error is thrown whenever a big number calculation fails (such as n / 0).
	 *
	 * @author Franck WOLFF
	 */
	public class ArithmeticError extends BigNumberError
	{
		/**
		 * Constructs a new <code>ArithmeticError</code>
		 *
		 * @param message the message of this error.
		 * @param id the numeric code of this error.
		 */
		function ArithmeticError(message:* = "", id:* = 0)
		{
			super(message, id);
		}
	}
}
