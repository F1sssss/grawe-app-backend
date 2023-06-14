const sgMail = require('@sendgrid/mail');
const emailRegister = require('./EmailTemplates/emailRegister');
const emailForgotPassword = require('./EmailTemplates/emailForgotPassword');
const { SENDGRID_API_KEY, EMAIL_FROM, FRONTEND_URL } = process.env;

module.exports = class Email {
  constructor(email, username, id, email_verification_token) {
    this.emailTo = email;
    this.username = username;
    this.id = id;
    this.email_verification_token = email_verification_token;
  }
  async sendEmailVerification() {
    sgMail.setApiKey(SENDGRID_API_KEY);
    try {
      const msg = {
        to: this.emailTo,
        from: EMAIL_FROM, // Change to your verified sender
        subject: '[GRAWE] Verification email',
        html: emailRegister(
          this.username,
          `${FRONTEND_URL}/api/v1/users/signup/verification/?id=${this.id}?token=${this.email_verification_token}`
        )
      };
      await sgMail.send(msg);

      return { message: 'Email sent successfully!', statusCode: 200 };
    } catch (err) {
      console.log(err);
      return { message: 'Error during sending email!:' + err, statusCode: 500 };
    }
  }

  async sendEmailRetrievingPassword() {
    sgMail.setApiKey(SENDGRID_API_KEY);
    try {
      const msg = {
        to: this.emailTo,
        from: EMAIL_FROM, // Change to your verified sender
        subject: '[GRAWE] Password reset',
        html: emailForgotPassword(
          this.username,
          `${FRONTEND_URL}/api/v1/users/forgot-password/?id=${this.id}&&?token=${this.email_verification_token}`
        )
      };
      await sgMail.send(msg);

      return { message: 'Email sent successfully!', statusCode: 200 };
    } catch (err) {
      console.log(err);
      return { message: 'Error during sending email!:' + err, statusCode: 500 };
    }
  }
};
