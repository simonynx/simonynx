package fj1.modules.newmail.signals
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.utilities.SignalSet;

	public class MailSignal extends SignalSet
	{
		/**
		 * 显示邮件面板
		 * @return
		 *
		 */
		public function get showMailPanel():ISignal
		{
			return getSignal("showMailPanel", Signal);
		}

		/**
		 * 发送邮件
		 * @return
		 *
		 */
		public function get sendMail():ISignal
		{
			return getSignal("sendMail", Signal);
		}

		/**
		 * 删除邮件
		 * @return
		 *
		 */
		public function get mailDelete():ISignal
		{
			return getSignal("mailDelete", Signal);
		}

		/**
		 * 更新邮件内容
		 * @return
		 *
		 */
		public function get updateMailContent():ISignal
		{
			return getSignal("updateMailContent", Signal);
		}

		/**
		 * 判断设置邮件标题
		 * @return
		 *
		 */
		public function get setMailTitle():ISignal
		{
			return getSignal("setMailTitle", Signal);
		}

		/**
		 * 从聊天框里发送邮件
		 * @return
		 *
		 */
		public function get writeMailForChat():ISignal
		{
			return getSignal("writeMailForChat", Signal);
		}

		/**
		 * 发送邮件成功
		 * @return
		 *
		 */
		public function get sendMailComplete():ISignal
		{
			return getSignal("sendMailComplete", Signal);
		}

		/**
		 * 回复邮件信号
		 * @return
		 *
		 */
		public function get replyMail():ISignal
		{
			return getSignal("replyMail", Signal);
		}

		/**
		 * 设置收件人名字和标题
		 * @return
		 *
		 */
		public function get setNameAndTitle():ISignal
		{
			return getSignal("setNameAndTitle", Signal);
		}

		/**
		 * 改变邮件图标状态
		 * @return
		 *
		 */
		public function get changeMailIcon():ISignal
		{
			return getSignal("palyMailIcon", Signal);
		}

		/**
		 * 发送邮件的数量
		 * @return
		 *
		 */
		public function get setSendedMailNum():ISignal
		{
			return getSignal("setSendedMailNum", Signal, int);
		}

		/**
		 * 查询邮件返回的结果
		 * @return
		 *
		 */
		public function get mailDataComplete():ISignal
		{
			return getSignal("mailDataComplete", Signal);
		}

		/**
		 * mini好友名字
		 * @return
		 *
		 */
		public function get miniFriName():ISignal
		{
			return getSignal("miniFriName", Signal);
		}
	}
}
