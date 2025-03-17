const ValidationRegEx = require('../../src/utils/ValidationRegEx');

describe('ValidationRegEx', () => {
  describe('emailRegex', () => {
    it('should match valid email addresses', () => {
      expect('test@example.com').toMatch(ValidationRegEx.emailRegex);
      expect('user.name+tag@example.co.uk').toMatch(ValidationRegEx.emailRegex);
    });

    it('should not match invalid email addresses', () => {
      expect('invalidemail').not.toMatch(ValidationRegEx.emailRegex);
      expect('invalid@email@example.com').not.toMatch(ValidationRegEx.emailRegex);
    });
  });

  describe('emailRegexGrawe', () => {
    it('should match valid Grawe email addresses', () => {
      expect('test@grawe.me').toMatch(ValidationRegEx.emailRegexGrawe);
      expect('user.name@grawe.me').toMatch(ValidationRegEx.emailRegexGrawe);
    });

    it('should not match non-Grawe email addresses', () => {
      expect('test@example.com').not.toMatch(ValidationRegEx.emailRegexGrawe);
      expect('user@grawe.com').not.toMatch(ValidationRegEx.emailRegexGrawe);
    });
  });

  describe('passwordRegex', () => {
    it('should match valid passwords', () => {
      expect('Pass1!').toMatch(ValidationRegEx.passwordRegex);
      expect('StrongP@ssw0rd').toMatch(ValidationRegEx.passwordRegex);
    });

    it('should not match invalid passwords', () => {
      expect('weakpassword').not.toMatch(ValidationRegEx.passwordRegex);
      expect('NoSpecialChar1').not.toMatch(ValidationRegEx.passwordRegex);
      expect('short1!').not.toMatch(ValidationRegEx.passwordRegex);
    });
  });

  describe('usernameRegex', () => {
    it('should match valid usernames', () => {
      expect('user123').toMatch(ValidationRegEx.usernameRegex);
      expect('USERNAME').toMatch(ValidationRegEx.usernameRegex);
    });

    it('should not match invalid usernames', () => {
      expect('user').not.toMatch(ValidationRegEx.usernameRegex);
      expect('user@123').not.toMatch(ValidationRegEx.usernameRegex);
      expect('user name').not.toMatch(ValidationRegEx.usernameRegex);
    });
  });
});
