// src/config.js — nạp cấu hình từ biến môi trường, không hardcode secret.
'use strict';

const REQUIRED = [
  'APP_ENV',
  'DB_HOST',
  'DB_NAME',
  'DB_USER',
  'DB_PASSWORD',
  'JWT_SECRET',
  'PAYMENT_API_KEY',
];

function loadConfig(env = process.env) {
  const missing = REQUIRED.filter((k) => !env[k]);
  if (missing.length) {
    throw new Error(`Thiếu biến môi trường bắt buộc: ${missing.join(', ')}`);
  }
  return Object.freeze({
    env: env.APP_ENV,
    db: {
      host: env.DB_HOST,
      port: Number(env.DB_PORT || 5432),
      name: env.DB_NAME,
      user: env.DB_USER,
      password: env.DB_PASSWORD,
    },
    jwtSecret: env.JWT_SECRET,
    paymentApiKey: env.PAYMENT_API_KEY,
  });
}

module.exports = { loadConfig };
