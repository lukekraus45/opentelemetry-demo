import '../styles/globals.css';
import { QueryClient, QueryClientProvider } from 'react-query';
import App, { AppContext, AppProps } from 'next/app';
import CurrencyProvider from '../providers/Currency.provider';
import CartProvider from '../providers/Cart.provider';
import { ThemeProvider } from 'styled-components';
import Theme from '../styles/Theme';
import { datadogRum } from '@datadog/browser-rum';

declare global {
  interface Window {
    ENV: {
      NEXT_PUBLIC_PLATFORM?: string;
      NEXT_PUBLIC_OTEL_SERVICE_NAME?: string;
      NEXT_PUBLIC_OTEL_EXPORTER_OTLP_TRACES_ENDPOINT?: string;
      DD_RUM_APPLICATION_ID: string;
      DD_RUM_CLIENT_TOKEN: string;
    };
  }
}

/*
if (typeof window !== 'undefined') {
  const collector = getCookie('otelCollectorUrl')?.toString() || '';
  FrontendTracer(collector);
}
*/
const { DD_RUM_APPLICATION_ID = '', DD_RUM_CLIENT_TOKEN = '', NEXT_PUBLIC_OTEL_SERVICE_NAME = 'frontend' } = typeof window !== 'undefined' ? window.ENV : {};

datadogRum.init({
    applicationId: DD_RUM_APPLICATION_ID,
    clientToken: DD_RUM_CLIENT_TOKEN,
    site: 'datadoghq.com',
    service: NEXT_PUBLIC_OTEL_SERVICE_NAME,
    
    // Specify a version number to identify the deployed version of your application in Datadog 
    // version: '1.0.0',
    sampleRate: 100,
    sessionReplaySampleRate: 20,
    trackInteractions: true,
    trackResources: true,
    trackLongTasks: true,
    defaultPrivacyLevel:'mask-user-input'
});

datadogRum.startSessionReplayRecording();

const queryClient = new QueryClient();

function MyApp({ Component, pageProps }: AppProps) {
  return (
    <ThemeProvider theme={Theme}>
      <QueryClientProvider client={queryClient}>
        <CurrencyProvider>
          <CartProvider>
            <Component {...pageProps} />
          </CartProvider>
        </CurrencyProvider>
      </QueryClientProvider>
    </ThemeProvider>
  );
}

MyApp.getInitialProps = async (appContext: AppContext) => {
  const appProps = await App.getInitialProps(appContext);

  return { ...appProps };
};

export default MyApp;
