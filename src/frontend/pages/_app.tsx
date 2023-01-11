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
    };
  }
}

/* Remove OTel tracing libraries
if (typeof window !== 'undefined') {
  const collector = getCookie('otelCollectorUrl')?.toString() || '';
  FrontendTracer(collector);
}*/

// Use Datadog RUM with tracing propagation
datadogRum.init({
  applicationId: '[RUM_APPLICATION_ID]',
  clientToken: '[RUM_CLIENT_TOKEN]',
  site: 'datadoghq.com',
  service:'[RUM_SERVICE_NAME]',
  allowedTracingUrls: [{match: () => true, propagatorTypes: ['tracecontext'] }],
  version: '1.0.0',
  sessionSampleRate: 100,
  sessionReplaySampleRate: 100,
  traceSampleRate: 100,
  trackUserInteractions: true,
  defaultPrivacyLevel:'mask-user-input'
});

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
