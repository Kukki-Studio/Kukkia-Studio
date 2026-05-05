import { useMemo } from 'react';

export const useBaseUrl = (): string => {
    return useMemo(() => {
        return import.meta.env.REACT_APP_BASE_URL || import.meta.env.PUBLIC_URL || 'https://cms-absensi.vercel.app';
    }, []);
};