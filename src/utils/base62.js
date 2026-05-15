import { randomBytes } from "crypto";

const CHARSET =
  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

export function generateCode(length = 6) {
  let code = "";
  while (code.length < length) {
    const bytes = randomBytes(length * 2);
    for (const byte of bytes) {
      if (byte < 248 && code.length < length) {
        code += CHARSET[byte % 62];
      }
    }
  }
  return code;
}
