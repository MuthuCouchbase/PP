import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;

import java.security.KeyStore;

import org.apache.http.HttpVersion;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.HTTP;


    private void makePOSTRequestCreateTemplate(String path, String machineName, String templateName) throws IOException {
        DefaultHttpClient httpClient = getSSLDefaultHttpClient();
            HttpPost request = new HttpPost(
                    HOST + ":" + PORT + path);
        request.addHeader("Accept", "application/taskResponse.v1+json");
        request.addHeader("Content-Type", "application/json");

        String body = "{\"ABCD\":{\"createTemplateRequestDetails\":{\"v1\":{\"templateType\":\"CUSTOM_TEMPLATE\",\n" +
                "\t\"DEFG\":\"" + templateName + "\",\n" +
                "\t\"RELEASE\":null,\n" +
                "\t\"TEMPLATE\":null,\n" +
                "\t\"machine\":\"" + sourceStageName + ".qa.paypal.com\",\n" +
                "\t\"publishingMode\":\"ALWAYS_ENABLED\",\n" +
                "\t\"manifests\":null,\n";

        StringEntity params =new StringEntity(body, ContentType.APPLICATION_JSON);
        request.setEntity(params);

        HttpResponse response = httpClient.execute(request);
        processResponse(httpClient, response);
    }
    
    public DefaultHttpClient getSSLDefaultHttpClient() {
        try {
            KeyStore trustStore = KeyStore.getInstance(KeyStore.getDefaultType());
            trustStore.load(null, null);

            SSLSocketFactory sf = new RelaxedSSLSocketFactory(trustStore);
            sf.setHostnameVerifier(SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);

            HttpParams params = new BasicHttpParams();
            HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
            HttpProtocolParams.setContentCharset(params, HTTP.UTF_8);

            SchemeRegistry registry = new SchemeRegistry();
            registry.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));
            registry.register(new Scheme("https", sf, 443));

            ClientConnectionManager ccm = new ThreadSafeClientConnManager(params, registry);

            return new DefaultHttpClient(ccm, params);
        } catch (Exception e) {
            return new DefaultHttpClient();
        }
    }    
