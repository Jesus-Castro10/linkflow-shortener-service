const PROTOCOL_REGEX = /^https?:\/\/[^\s]+\.[^\s]+/i;

export function isValidUrl(url) {
  if (typeof url !== "string") return false;
  if (!PROTOCOL_REGEX.test(url)) return false;
  try {
    const { protocol } = new URL(url);
    return protocol === "http:" || protocol === "https:";
  } catch {
    return false;
  }
}
