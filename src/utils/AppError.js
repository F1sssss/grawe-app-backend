module.exports = class AppError extends Error {
  constructor(message, statusCode, statusMessage, metadata = {}) {
    super(message);

    this.statusCode = statusCode;
    this.statusMessage = statusMessage;
    this.metadata = metadata;
    this.timestamp = new Date().toISOString();
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);

    this.parseStackTrace();
  }

  parseStackTrace() {
    if (!this.stack) return;

    const stackLines = this.stack.split('\n');
    const appCodeLine = stackLines.find((line) => line.includes('/src/') && !line.includes('node_modules'));

    if (appCodeLine) {
      // Parse out the file path and line number
      const match = appCodeLine.match(/\((.+):(\d+):(\d+)\)$/);
      if (match) {
        this.location = {
          filePath: match[1],
          lineNumber: parseInt(match[2], 10),
          columnNumber: parseInt(match[3], 10),
          fileName: match[1].split('/').pop(),
        };
      }
    }
  }

  toJSON() {
    return {
      message: this.message,
      statusCode: this.statusCode,
      statusMessage: this.statusMessage,
      timestamp: this.timestamp,
      isOperational: this.isOperational,
      location: this.location,
      metadata: this.metadata,
      stack: this.stack,
    };
  }
};
