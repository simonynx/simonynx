package org.granite.math
{
	import flash.utils.getQualifiedClassName;

	/**
	 * This error is the base class of all GraniteDS math errors. It may be thrown
	 * itself when a low level problem is detected (assertion failed).
	 *
	 * @author Franck WOLFF
	 */
	public class BigNumberError extends Error
	{
		/**
		 * Constructs a new <code>BigNumberError</code>
		 *
		 * @param message the message of this error.
		 * @param id the numeric code of this error.
		 */
		function BigNumberError(message:* = "", id:* = 0)
		{
			super(message, id);
			name = getQualifiedClassName(this);
		}
	}
}
