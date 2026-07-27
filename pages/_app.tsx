import Layout from 'components/Layout';
import config from 'lib/env';
import App from 'next/app';
import type { AppContext, AppProps } from 'next/app';
import { useEffect } from 'react';
import TagManager from 'react-gtm-module';
import 'styles/globals.css';

type MyAppProps = AppProps & { idpTitle: string };

function MyApp({ Component, pageProps, idpTitle }: MyAppProps) {
  useEffect(() => {
    if (process.env.NEXT_PUBLIC_GTM_ID && process.env.NEXT_PUBLIC_GTM_ID.length > 0) {
      TagManager.initialize({ gtmId: process.env.NEXT_PUBLIC_GTM_ID });
    }
  }, []);

  return (
    <Layout idpTitle={idpTitle}>
      <Component {...pageProps} />
    </Layout>
  );
}

MyApp.getInitialProps = async (appContext: AppContext) => {
  const appProps = await App.getInitialProps(appContext);
  return { ...appProps, idpTitle: config.idpTitle };
};

export default MyApp;
