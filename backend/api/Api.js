export const BaseUrl = import.meta.env.VERCEL_PUBLIC_API_BASE_UR || 'url';


export async function apiFetcher<T>(url: string, options?: RequestInit): Promise<T> {
  const res = await fetch(`${BASE_URL}/api${url}`, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });

  const isJson = res.headers.get('content-type')?.includes('application/json');
  const data = isJson ? await res.json() : null;

  if (!res.ok) {
    const errorMessage = data?.error || 'API Error';
    throw new Error(errorMessage);
  }

  return data;
}