import  winston from 'winston';

const customFormat = winston.format.printf(
  ({ level, message, timestamp, context }) => {
    return `[Nest] ${process.pid} - ${timestamp} ${level} [${context}] ${message}`;
  },
);

const timestampFormat = winston.format.timestamp({
  format: 'YYYY-MM-DD HH:mm:ss',
});

const logFormat = winston.format.combine(timestampFormat, customFormat);

const levelFilter = (level) =>
  winston.format((info) => {
    return info.level === level ? info : false;
  })();

const fileTransport = (level) =>
  new winston.transports.File({
    filename: `logs/${level}.log`,
    level: 'debug',
    format: winston.format.combine(levelFilter(level), logFormat),
  });

export const loggerConfig = {
  transports: [
    new winston.transports.Console({
      level: 'debug',
      format: winston.format.combine(winston.format.colorize(), logFormat),
    }),
    fileTransport('debug'),
    fileTransport('info'),
    fileTransport('warn'),
    fileTransport('error'),
  ],
};
