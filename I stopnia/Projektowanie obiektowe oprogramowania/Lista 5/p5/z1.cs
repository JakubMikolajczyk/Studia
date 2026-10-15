using System.Net.Mail;

namespace p5;

public class z1
{
    class SmtpFacade
    {

        public void Send(String From, String To, string Subject, string Body,
            Stream Attachment, string AttachmentMimeType)
        {
            SmtpClient client = new SmtpClient();
            MailMessage message = new MailMessage(new MailAddress(From), new MailAddress(To));
            message.Subject = Subject;
            message.Body = Body;
            message.Attachments.Add(new Attachment(Attachment,"abc", AttachmentMimeType));
            client.Send(message);
        }
    }
}