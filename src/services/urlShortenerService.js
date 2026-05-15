import { isValidUrl } from "../utils/urlValidator.js";
import { generateCode } from "../utils/base62.js";
import { getByCode, save } from "../repositories/urlRepository.js";

const MAX_ATTEMPTS = 5;

export async function shortenUrl(longUrl) {
  if (!isValidUrl(longUrl)) {
    const error = new Error("Invalid URL");
    error.errorCode = "INVALID_URL";
    throw error;
  }

  let code = null;

  for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
    const candidate = generateCode();
    const existing = await getByCode(candidate);

    if (!existing) {
      code = candidate;
      break;
    }
  }

  if (!code) {
    const error = new Error("Could not generate a unique code");
    error.errorCode = "COLLISION_ERROR";
    throw error;
  }

  await save(code, longUrl);

  return code;
}
