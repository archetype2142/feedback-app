export function getCSRFToken() {
  const csrfToken = document.querySelector('meta[name="csrf-token"]');
  return csrfToken ? csrfToken.content : '';
}
