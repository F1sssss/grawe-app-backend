const sgMail = require('@sendgrid/mail');
const emailRegister = require('../EmailTemplates/emailRegister');
const emailForgotPassword = require('../EmailTemplates/emailForgotPassword');
const logger = require('../../logging/winstonSetup');
const { SENDGRID_API_KEY, EMAIL_FROM, FRONTEND_URL } = process.env;

module.exports = class Email {
  constructor(user) {
    console.log(user);
    this.emailTo = user.email;
    this.username = user.username;
    this.id = user.ID;
    this.email_verification_token = user.email_verification_token;
  }
  async sendEmailVerification() {
    sgMail.setApiKey(SENDGRID_API_KEY);

    const msg = {
      to: this.emailTo,
      from: EMAIL_FROM, // Change to your verified sender
      subject: '[GRAWE] Verifiction email',
      html: emailRegister(this.username, `${FRONTEND_URL}/api/v1/users/signup/verification/?id=${this.id}?token=${this.email_verification_token}`),
    };

    try {
      await sgMail.send(msg);
      logger.info('Email sent successfully! To user: ' + this.username + ' with email: ' + this.emailTo + ' for email verification.');
    } catch (err) {
      logger.error(err);
      console.log(err);
    }

    return { message: 'Email sent successfully!', statusCode: 200 };
  }

  async sendEmailRetrievingPassword() {
    sgMail.setApiKey(SENDGRID_API_KEY);

    const msg = {
      to: this.emailTo,
      from: EMAIL_FROM, // Change to your verified sender
      subject: '[GRAWE] Password reset',
      html: emailForgotPassword(this.username, `${FRONTEND_URL}/api/v1/users/forgot-password/?id=${this.id}&token=${this.email_verification_token}`),
    };

    try {
      await sgMail.send(msg);
      logger.info('Email sent successfully! To user: ' + this.username + ' with email: ' + this.emailTo + ' for password reset.');
    } catch (err) {
      logger.error(err);
      console.log(err);
    }

    return { message: 'Email sent successfully!', statusCode: 200 };
  }
};
