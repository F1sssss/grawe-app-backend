module.exports = class SQLParam {
  constructor(name, value, type) {
    this.name = name;
    this.value = value;
    this.type = type;
  }
};
